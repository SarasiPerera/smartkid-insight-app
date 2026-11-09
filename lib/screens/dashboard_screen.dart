import 'package:flutter/material.dart';

import '../data/activity_data.dart';
import '../models/models.dart';
import '../services/firestore_service.dart';
import '../services/scoring.dart';
import '../theme.dart';

/// Progress dashboard. Parents see only the sessions they created; teachers and
/// researchers see all sessions (enforced by firestore.rules as well as here).
/// Loads each session's responses one by one, which is fine for a pilot of
/// 30-50 children but should become a collection-group query at larger scale.
class DashboardScreen extends StatefulWidget {
  final UserProfile user;
  final FirestoreService firestore;
  const DashboardScreen({
    super.key,
    required this.user,
    required this.firestore,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<_DashData> _future = _load();

  Future<_DashData> _load() async {
    final sessions = await widget.firestore.fetchSessions(widget.user);
    final all = <AssessmentResponse>[];
    for (final s in sessions) {
      all.addAll(
        await widget.firestore.fetchResponses(s['sessionId'] as String),
      );
    }
    return _DashData(sessions, all);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_DashData>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError || snap.data == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Could not load data. Check your connection and permissions.',
                    textAlign: TextAlign.center,
                    style: sinhalaText(14),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => setState(() => _future = _load()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        final data = snap.data!;
        final scores = computeDomainScores(data.responses);
        final children = data.sessions.map((s) => s['childId']).toSet().length;
        return RefreshIndicator(
          onRefresh: () async => setState(() => _future = _load()),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Progress dashboard',
                style: sinhalaText(22, weight: FontWeight.w900),
              ),
              Text(
                widget.user.role == UserRole.parent
                    ? 'Showing your own sessions only.'
                    : 'Showing all sessions (anonymised IDs only).',
                style: sinhalaText(12, color: AppColors.inkSoft),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _stat('Children', '$children'),
                  _stat('Sessions', '${data.sessions.length}'),
                  _stat('Responses', '${data.responses.length}'),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Accuracy by activity',
                style: sinhalaText(16, weight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              ...scores.map((s) {
                final info = activityInfos[s.activityType]!;
                final color = levelColor(s.accuracyPercent);
                final has = s.totalQuestions > 0;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            info.emoji,
                            style: const TextStyle(fontSize: 22),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              info.titleEnglish,
                              style: sinhalaText(14, weight: FontWeight.w800),
                            ),
                          ),
                          Text(
                            has
                                ? '${s.accuracyPercent}% · ${s.level.label}'
                                : 'No data',
                            style: TextStyle(
                              color: has ? color : AppColors.inkSoft,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: has ? s.accuracyPercent / 100 : 0,
                          minHeight: 9,
                          backgroundColor: AppColors.line,
                          valueColor: AlwaysStoppedAnimation(color),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${s.totalQuestions} responses · avg ${formatSeconds(s.avgTimeMs)}',
                        style: sinhalaText(11, color: AppColors.inkSoft),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 10),
              Text(
                'Recent sessions',
                style: sinhalaText(16, weight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              ...data.sessions
                  .take(15)
                  .map(
                    (s) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        s['isComplete'] == true
                            ? Icons.check_circle
                            : Icons.timelapse,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        '${s['childId'] ?? '-'}',
                        style: sinhalaText(13, weight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        'Age band ${s['ageBand'] ?? '-'} · ${(s['completedActivities'] as List?)?.length ?? 0} activities',
                        style: sinhalaText(11.5, color: AppColors.inkSoft),
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }

  Widget _stat(String label, String value) => Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: sinhalaText(
              22,
              weight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
          Text(label, style: sinhalaText(11.5, color: AppColors.inkSoft)),
        ],
      ),
    ),
  );
}

class _DashData {
  final List<Map<String, dynamic>> sessions;
  final List<AssessmentResponse> responses;
  _DashData(this.sessions, this.responses);
}

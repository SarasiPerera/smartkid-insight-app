import 'package:flutter/material.dart';

import '../data/activity_data.dart';
import '../models/models.dart';
import '../services/scoring.dart';
import '../theme.dart';
import '../widgets/mascot_owl.dart';

class ResultsScreen extends StatelessWidget {
  final ChildProfile child;
  final List<AssessmentResponse> responses;
  final VoidCallback onHome;
  final VoidCallback onDashboard;

  const ResultsScreen({
    super.key,
    required this.child,
    required this.responses,
    required this.onHome,
    required this.onDashboard,
  });

  @override
  Widget build(BuildContext context) {
    final scores = computeDomainScores(responses)
        .where((s) => s.totalQuestions > 0)
        .toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: MascotOwl(
              emotion: OwlEmotion.bounce,
              size: 110,
              speech: 'සුබ පැතුම්! නියමයි! 🎉',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Domain performance',
            style: sinhalaText(18, weight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          if (scores.isEmpty)
            Text(
              'No activities were completed in this session.',
              style: sinhalaText(13, color: AppColors.inkSoft),
            ),
          ...scores.map((s) {
            final info = activityInfos[s.activityType]!;
            final color = levelColor(s.accuracyPercent);
            final icon = s.level == PerformanceLevel.strong
                ? Icons.check_circle
                : s.level == PerformanceLevel.developing
                ? Icons.trending_up
                : Icons.flag;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(info.emoji, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          info.titleEnglish,
                          style: sinhalaText(15, weight: FontWeight.w800),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(icon, size: 16, color: color),
                            const SizedBox(width: 4),
                            Text(
                              s.level.label,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: s.accuracyPercent / 100,
                      minHeight: 10,
                      backgroundColor: AppColors.line,
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${s.correctCount}/${s.totalQuestions} correct · ${s.accuracyPercent}% · avg ${formatSeconds(s.avgTimeMs)}',
                    style: sinhalaText(11.5, color: AppColors.inkSoft),
                  ),
                ],
              ),
            );
          }),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Scoring guide: Strong ≥ 80% · Developing 50–79% · Weak < 50%.\n'
              'This is a screening and progress-tracking tool, not a clinical diagnosis.',
              style: sinhalaText(11.5, color: AppColors.ink),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onHome,
            child: const Text('Return to home'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: onDashboard,
            child: const Text('View progress dashboard'),
          ),
        ],
      ),
    );
  }
}

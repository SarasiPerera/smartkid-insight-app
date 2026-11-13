import 'package:flutter/material.dart';

import '../data/activity_data.dart';
import '../models/models.dart';
import '../theme.dart';
import '../widgets/mascot_owl.dart';
import 'profile_create_screen.dart' show kAvatars;

class ActivityMenuScreen extends StatelessWidget {
  final ChildProfile child;
  final AssessmentSession session;
  final ValueChanged<ActivityType> onSelect;
  final VoidCallback onRestBreak;
  final VoidCallback onFinish;

  const ActivityMenuScreen({
    super.key,
    required this.child,
    required this.session,
    required this.onSelect,
    required this.onRestBreak,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final done = session.completedActivities.length;
    final total = ActivityType.values.length;
    final percent = (done / total * 100).round();
    final message = done == 0
        ? 'එන්න! සෙල්ලම් කරමු! 🎈'
        : done >= 4
            ? 'තව එක් වැඩක් විතරයි! 🌟'
            : 'නියමයි! දිගටම කරගෙන යමු! 👍';

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 650;
        const gap = 12.0;
        final tileWidth = wide
            ? (constraints.maxWidth - 40 - gap) / 2
            : constraints.maxWidth - 40;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _sessionHeader(done, total, percent, message, wide),
                  if (done >= 2) ...[
                    const SizedBox(height: 14),
                    _restBanner(),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Text('Select Assessment Activity', style: sinhalaText(16, weight: FontWeight.w900))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(30)),
                        child: Text('Tap to Play', style: sinhalaText(10, color: AppColors.inkSoft, weight: FontWeight.w800)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: ActivityType.values.map((type) {
                      final info = activityInfos[type]!;
                      final isDone = session.completedActivities.contains(type);
                      return SizedBox(
                        width: tileWidth,
                        child: _activityTile(info, isDone, () => onSelect(type)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 22),
                  ElevatedButton.icon(
                    onPressed: onFinish,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Complete Session & View Results'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sessionHeader(int done, int total, int percent, String message, bool wide) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFED7AA)),
        boxShadow: const [BoxShadow(color: Color(0x080F172A), blurRadius: 12, offset: Offset(0, 3))],
      ),
      child: Row(
        children: [
          Text(kAvatars[child.avatarIndex % kAvatars.length], style: const TextStyle(fontSize: 42)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${child.nickname}'s Session", style: sinhalaText(17, weight: FontWeight.w900)),
                Text('ID: ${child.childId}  •  Age Band: ${child.ageBand.key} years', style: sinhalaText(10.5, color: AppColors.inkSoft)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text('Overall Assessment Progress', style: sinhalaText(10.5, weight: FontWeight.w800))),
                    Text('$done of $total ($percent%)', style: sinhalaText(10, weight: FontWeight.w800, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(value: done / total, minHeight: 10, backgroundColor: AppColors.line, valueColor: const AlwaysStoppedAnimation(AppColors.primary)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          MascotOwl(emotion: done >= 2 ? OwlEmotion.bounce : OwlEmotion.cheerful, size: wide ? 92 : 62, speech: wide ? message : null),
        ],
      ),
    );
  }

  Widget _restBanner() => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFE0F2FE), border: Border.all(color: const Color(0xFFBAE6FD)), borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFF0284C7), borderRadius: BorderRadius.circular(13)), child: const Icon(Icons.coffee, color: Colors.white)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Rest & Breathing Break Suggested', style: sinhalaText(12, weight: FontWeight.w900, color: const Color(0xFF075985))), Text("Prevent fatigue with Ollie's 30-second Sinhala breathing exercise.", style: sinhalaText(10.5, color: const Color(0xFF0369A1)))])),
            TextButton(onPressed: onRestBreak, child: const Text('Take break')),
          ],
        ),
      );

  Widget _activityTile(ActivityInfo info, bool isDone, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: isDone ? AppColors.strong.withOpacity(.55) : info.color.withOpacity(.55), width: 1.7),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 48, height: 48, alignment: Alignment.center, decoration: BoxDecoration(color: info.color.withOpacity(.14), borderRadius: BorderRadius.circular(15)), child: Text(info.emoji, style: const TextStyle(fontSize: 27))),
                  const Spacer(),
                  if (isDone)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(30)),
                      child: const Row(children: [Icon(Icons.check_circle, size: 13, color: AppColors.strong), SizedBox(width: 4), Text('✓ Done', style: TextStyle(color: AppColors.strong, fontWeight: FontWeight.w900, fontSize: 10))]),
                    ),
                ],
              ),
              const SizedBox(height: 11),
              Text(info.titleSinhala, style: sinhalaText(15, weight: FontWeight.w900)),
              Text(info.titleEnglish, style: sinhalaText(11.5, weight: FontWeight.w800, color: AppColors.inkSoft)),
              const SizedBox(height: 4),
              Text(info.descriptionSinhala, style: sinhalaText(10.5, color: AppColors.inkSoft)),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 9),
              Row(
                children: [
                  Expanded(child: Text('Age Band: ${child.ageBand.key} years', style: sinhalaText(10, color: AppColors.inkSoft))),
                  Text(isDone ? 'Replay Activity  →' : 'Start Activity  →', style: TextStyle(color: isDone ? AppColors.strong : AppColors.primary, fontSize: 10.5, fontWeight: FontWeight.w900)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

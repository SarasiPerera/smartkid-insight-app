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
    final message = done == 0
        ? 'එන්න! සෙල්ලම් කරමු! 🎈'
        : done < total
        ? (done == total - 1
              ? 'තව එක් වැඩක් විතරයි! 🌟'
              : 'නියමයි! දිගටම කරගෙන යමු! 👍')
        : 'සුබ පැතුම්! 🎉';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                kAvatars[child.avatarIndex % kAvatars.length],
                style: const TextStyle(fontSize: 38),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child.nickname,
                      style: sinhalaText(18, weight: FontWeight.w900),
                    ),
                    Text(
                      '${child.ageBand.label} · ${child.ageBand.choices} choices per question',
                      style: sinhalaText(12, color: AppColors.inkSoft),
                    ),
                  ],
                ),
              ),
              MascotOwl(size: 64),
            ],
          ),
          const SizedBox(height: 14),
          Text(message, style: sinhalaText(15, weight: FontWeight.w800)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: done / total,
              minHeight: 12,
              backgroundColor: AppColors.line,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$done of $total activities completed',
            style: sinhalaText(11.5, color: AppColors.inkSoft),
          ),
          const SizedBox(height: 16),
          ...ActivityType.values.map((t) {
            final info = activityInfos[t]!;
            final isDone = session.completedActivities.contains(t);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => onSelect(t),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: kMinTap),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: isDone
                            ? AppColors.strong
                            : info.color.withOpacity(0.5),
                        width: 3,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: info.color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            info.emoji,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                info.titleSinhala,
                                style: sinhalaText(16, weight: FontWeight.w900),
                              ),
                              Text(
                                info.titleEnglish,
                                style: sinhalaText(
                                  12,
                                  color: AppColors.inkSoft,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isDone)
                          const Row(
                            children: [
                              Icon(Icons.check_circle, color: AppColors.strong),
                              SizedBox(width: 4),
                              Text(
                                'Done',
                                style: TextStyle(
                                  color: AppColors.strong,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          )
                        else
                          const Icon(
                            Icons.play_circle_fill,
                            color: AppColors.primary,
                            size: 34,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onRestBreak,
                  child: const Text('Take a break'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onFinish,
                  child: const Text('Finish & view results'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

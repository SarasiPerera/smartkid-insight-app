import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme.dart';
import '../widgets/mascot_owl.dart';
import 'profile_create_screen.dart' show kAvatars;

class HomeScreen extends StatelessWidget {
  final UserProfile user;
  final List<ChildProfile> children;
  final ChildProfile? currentChild;
  final ValueChanged<ChildProfile> onSelectChild;
  final VoidCallback onCreateChild;
  final VoidCallback onStartSession;

  const HomeScreen({
    super.key,
    required this.user,
    required this.children,
    required this.currentChild,
    required this.onSelectChild,
    required this.onCreateChild,
    required this.onStartSession,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: MascotOwl(
              emotion: OwlEmotion.bounce,
              size: 120,
              speech: 'සාදරයෙන් පිළිගනිමු! 🦉',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Children on this device',
            style: sinhalaText(16, weight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          if (children.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.line),
              ),
              child: Text(
                'No child profile yet. Add one to start a screening session.',
                style: sinhalaText(13, color: AppColors.inkSoft),
              ),
            ),
          ...children.map((c) {
            final selected = currentChild?.childId == c.childId;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: selected ? AppColors.primarySoft : Colors.white,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => onSelectChild(c),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.line,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          kAvatars[c.avatarIndex % kAvatars.length],
                          style: const TextStyle(fontSize: 34),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.nickname,
                                style: sinhalaText(16, weight: FontWeight.w800),
                              ),
                              Text(
                                '${c.ageBand.label} · ID ${c.childId}',
                                style: sinhalaText(
                                  11.5,
                                  color: AppColors.inkSoft,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (selected)
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 4),
          OutlinedButton.icon(
            onPressed: onCreateChild,
            icon: const Icon(Icons.add),
            label: const Text('Add child profile'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: children.isEmpty ? null : onStartSession,
            child: const Text('Start screening session'),
          ),
        ],
      ),
    );
  }
}

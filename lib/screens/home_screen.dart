import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme.dart';
import '../widgets/mascot_owl.dart';
import 'profile_create_screen.dart' show kAvatars;

/// Home screen recreated from the React reference HomeScreen.tsx.
/// Child nicknames remain local; only anonymised child IDs are displayed.
class HomeScreen extends StatelessWidget {
  final UserProfile user;
  final List<ChildProfile> children;
  final ChildProfile? currentChild;
  final ValueChanged<ChildProfile> onSelectChild;
  final VoidCallback onCreateChild;
  final VoidCallback onStartSession;
  final ValueChanged<String> onNavigate;

  const HomeScreen({
    super.key,
    required this.user,
    required this.children,
    required this.currentChild,
    required this.onSelectChild,
    required this.onCreateChild,
    required this.onStartSession,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final firstName = user.email.split('@').first;
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 700;
        final profileColumns = constraints.maxWidth >= 900
            ? 3
            : constraints.maxWidth >= 560
                ? 2
                : 1;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(wide ? 24 : 16, 18, wide ? 24 : 16, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHero(context, firstName, wide),
                  const SizedBox(height: 22),
                  _buildProfiles(context, profileColumns),
                  const SizedBox(height: 16),
                  _buildShortcuts(context, profileColumns),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHero(BuildContext context, String firstName, bool wide) {
    return Container(
      padding: EdgeInsets.all(wide ? 28 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF97316), Color(0xFFF59E0B), Color(0xFFFACC15)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: wide
          ? Row(
              children: [
                Expanded(child: _heroText(firstName, context)),
                const SizedBox(width: 18),
                const MascotOwl(
                  emotion: OwlEmotion.bounce,
                  size: 138,
                  speech: 'සාදරයෙන් පිළිගනිමු! 🦉',
                ),
              ],
            )
          : Column(
              children: [
                _heroText(firstName, context),
                const SizedBox(height: 12),
                const MascotOwl(
                  emotion: OwlEmotion.bounce,
                  size: 120,
                  speech: 'සාදරයෙන් පිළිගනිමු! 🦉',
                ),
              ],
            ),
    );
  }

  Widget _heroText(String firstName, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.22),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            '✨  Sri Lanka Early Childhood Screening',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 13),
        Text(
          'ආයුබෝවන්, $firstName!',
          style: sinhalaText(
            25,
            color: Colors.white,
            weight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'Tap-based early literacy & cognitive screening designed for Sinhala preschool children aged 3–6 years.',
          style: sinhalaText(12.5, color: const Color(0xFFFFF7ED)),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: currentChild == null ? onCreateChild : onStartSession,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFFEA580C),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: Icon(currentChild == null ? Icons.add : Icons.play_arrow),
          label: Text(
            currentChild == null
                ? 'Create Child Profile to Begin'
                : 'Start Screening (${currentChild!.nickname})',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildProfiles(BuildContext context, int columns) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 10,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '👥  Child Screening Profiles',
                    style: sinhalaText(17, weight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select or create a child profile to start or continue assessments',
                    style: sinhalaText(11.5, color: AppColors.inkSoft),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: onCreateChild,
                icon: const Icon(Icons.add, size: 17),
                label: const Text('Add Child'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFB45309),
                  backgroundColor: const Color(0xFFFFF7ED),
                  side: const BorderSide(color: Color(0xFFFED7AA)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (children.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFCBD5E1),
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(18),
                color: const Color(0xFFFAFAFA),
              ),
              child: Column(
                children: [
                  const Text('👶', style: TextStyle(fontSize: 38)),
                  const SizedBox(height: 8),
                  Text(
                    'No Child Profile Found',
                    style: sinhalaText(14, weight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create a child profile with nickname, age band, and avatar to launch screening activities.',
                    textAlign: TextAlign.center,
                    style: sinhalaText(11.5, color: AppColors.inkSoft),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: onCreateChild,
                    child: const Text('+ Create First Child Profile'),
                  ),
                ],
              ),
            )
          else
            LayoutBuilder(
              builder: (context, box) {
                final count = columns.clamp(1, 3);
                const gap = 12.0;
                final width = (box.maxWidth - gap * (count - 1)) / count;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: children.map((child) {
                    final selected = currentChild?.childId == child.childId;
                    return SizedBox(
                      width: width,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => onSelectChild(child),
                        child: Container(
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFFFF7ED)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : const Color(0xFFE2E8F0),
                              width: selected ? 2 : 1.3,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                kAvatars[child.avatarIndex % kAvatars.length],
                                style: const TextStyle(fontSize: 30),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      child.nickname,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: sinhalaText(13, weight: FontWeight.w900),
                                    ),
                                    Text(
                                      child.childId,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 9.5,
                                        color: AppColors.inkSoft,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Age Band: ${child.ageBand.key} Years',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFFEA580C),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (selected)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.primary,
                                  size: 19,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildShortcuts(BuildContext context, int columns) {
    final cards = [
      _ShortcutData(
        title: 'Five Screening Activities',
        description:
            'Letters, Word-Picture, Colours, Shapes, & Counting with audio prompts.',
        action: 'Launch Screening',
        icon: Icons.play_arrow_rounded,
        tint: const Color(0xFFFFEDD5),
        accent: const Color(0xFFEA580C),
        onTap: currentChild == null ? onCreateChild : onStartSession,
      ),
      _ShortcutData(
        title: 'Research & Teacher Dashboard',
        description:
            'Domain accuracy charts, raw responses, session records, and research data.',
        action: 'View Dashboard',
        icon: Icons.bar_chart_rounded,
        tint: const Color(0xFFDBEAFE),
        accent: const Color(0xFF2563EB),
        onTap: () => onNavigate('dashboard'),
      ),
      _ShortcutData(
        title: 'Ethics & Privacy Standards',
        description:
            'Offline support, local nickname privacy, and standardised domain metrics.',
        action: 'Read Privacy Rules',
        icon: Icons.verified_user_outlined,
        tint: const Color(0xFFD1FAE5),
        accent: const Color(0xFF059669),
        onTap: () => onNavigate('welcome'),
      ),
    ];

    final count = columns.clamp(1, 3);
    return LayoutBuilder(
      builder: (context, box) {
        const gap = 12.0;
        final width = (box.maxWidth - gap * (count - 1)) / count;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: cards.map((card) {
            return SizedBox(
              width: width,
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: card.onTap,
                child: Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: card.tint),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x080F172A),
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: card.tint,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(card.icon, color: card.accent, size: 23),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        card.title,
                        style: sinhalaText(14, weight: FontWeight.w900),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        card.description,
                        style: sinhalaText(11, color: AppColors.inkSoft),
                      ),
                      const SizedBox(height: 13),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              card.action,
                              style: TextStyle(
                                color: card.accent,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward,
                              size: 15, color: card.accent),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _ShortcutData {
  final String title;
  final String description;
  final String action;
  final IconData icon;
  final Color tint;
  final Color accent;
  final VoidCallback onTap;

  const _ShortcutData({
    required this.title,
    required this.description,
    required this.action,
    required this.icon,
    required this.tint,
    required this.accent,
    required this.onTap,
  });
}

import 'dart:math';

import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme.dart';

const List<String> kAvatars = ['🐱', '🐰', '🦁', '🐻', '🐼', '🐸'];

class ProfileCreateScreen extends StatefulWidget {
  final String ownerId;
  final ValueChanged<ChildProfile> onCreated;
  final VoidCallback onCancel;
  const ProfileCreateScreen({
    super.key,
    required this.ownerId,
    required this.onCreated,
    required this.onCancel,
  });

  @override
  State<ProfileCreateScreen> createState() => _ProfileCreateScreenState();
}

class _ProfileCreateScreenState extends State<ProfileCreateScreen> {
  final _nickname = TextEditingController();
  AgeBand _band = AgeBand.a34;
  int _avatar = 0;

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  String _newChildId() {
    final r = Random.secure();
    final hex = List.generate(
      8,
      (_) => r.nextInt(16).toRadixString(16),
    ).join().toUpperCase();
    return 'KID-$hex';
  }

  void _save() {
    widget.onCreated(
      ChildProfile(
        childId: _newChildId(),
        nickname: _nickname.text.trim().isEmpty
            ? 'Little learner'
            : _nickname.text.trim(),
        ageBand: _band,
        avatarIndex: _avatar,
        ownerId: widget.ownerId,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create child profile',
            style: sinhalaText(22, weight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            'The nickname stays on this device only. The system assigns an anonymous ID.',
            style: sinhalaText(12.5, color: AppColors.inkSoft),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nickname,
            maxLength: 20,
            decoration: const InputDecoration(
              labelText: 'Nickname (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Text('Child\'s age', style: sinhalaText(13, weight: FontWeight.w800)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: AgeBand.values
                .map(
                  (b) => ChoiceChip(
                    label: Text('${b.label}  (${b.choices} choices)'),
                    selected: _band == b,
                    onSelected: (_) => setState(() => _band = b),
                    selectedColor: AppColors.primarySoft,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Choose an avatar',
            style: sinhalaText(13, weight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(kAvatars.length, (i) {
              final selected = _avatar == i;
              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => setState(() => _avatar = i),
                child: Container(
                  width: 72,
                  height: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primarySoft : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.line,
                      width: 3,
                    ),
                  ),
                  child: Text(
                    kAvatars[i],
                    style: const TextStyle(fontSize: 34),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Save & start session'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

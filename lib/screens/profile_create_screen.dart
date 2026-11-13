import 'dart:math';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme.dart';
import '../widgets/mascot_owl.dart';

const List<String> kAvatars = ['🐱', '🐰', '🦁', '🐻', '🐼', '🐸'];
const List<String> kAvatarNames = ['Cat', 'Bunny', 'Lion', 'Bear', 'Panda', 'Frog'];

class ProfileCreateScreen extends StatefulWidget {
  final String ownerId;
  final ValueChanged<ChildProfile> onCreated;
  final VoidCallback onCancel;
  const ProfileCreateScreen({super.key, required this.ownerId, required this.onCreated, required this.onCancel});
  @override
  State<ProfileCreateScreen> createState() => _ProfileCreateScreenState();
}

class _ProfileCreateScreenState extends State<ProfileCreateScreen> {
  final _nickname = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AgeBand _band = AgeBand.a45;
  int _avatar = 0;
  @override
  void dispose() { _nickname.dispose(); super.dispose(); }

  String _newChildId() { final r = Random.secure(); final hex = List.generate(8, (_) => r.nextInt(16).toRadixString(16)).join().toUpperCase(); return 'KID-$hex'; }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    widget.onCreated(ChildProfile(childId: _newChildId(), nickname: _nickname.text.trim().isEmpty ? 'Little learner' : _nickname.text.trim(), ageBand: _band, avatarIndex: _avatar, ownerId: widget.ownerId, createdAt: DateTime.now().toIso8601String()));
  }

  @override
  Widget build(BuildContext context) => Center(child: SingleChildScrollView(padding: const EdgeInsets.all(18), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 620), child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26), border: Border.all(color: AppColors.line), boxShadow: const [BoxShadow(color: Color(0x100F172A), blurRadius: 16, offset: Offset(0, 5))]), child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    Row(children: [const MascotOwl(size: 76, emotion: OwlEmotion.cheerful), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Create Child Profile', style: sinhalaText(21, weight: FontWeight.w900)), Text('Set up a learner profile to begin screening.', style: sinhalaText(11.5, color: AppColors.inkSoft))]))]),
    const SizedBox(height: 16),
    Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFBFDBFE))), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.shield_outlined, color: Color(0xFF2563EB)), const SizedBox(width: 9), Expanded(child: Text('Child privacy: nicknames are stored on this device only. The system creates an anonymised ID; no real name is sent to the research database.', style: sinhalaText(10.5, color: const Color(0xFF1E40AF))))])),
    const SizedBox(height: 16), Text('Child nickname (optional)', style: sinhalaText(12, weight: FontWeight.w900)), const SizedBox(height: 7), TextFormField(controller: _nickname, maxLength: 20, decoration: const InputDecoration(hintText: 'e.g. Nimali', prefixIcon: Icon(Icons.person_outline), filled: true, fillColor: Color(0xFFF8FAFC)), validator: (v) => (v != null && v.trim().length > 20) ? 'Use 20 characters or fewer.' : null),
    const SizedBox(height: 8), Text("Child's age group", style: sinhalaText(12, weight: FontWeight.w900)), const SizedBox(height: 8), Wrap(spacing: 8, runSpacing: 8, children: AgeBand.values.map((b) => ChoiceChip(label: Text('${b.label}  ·  ${b.choices} choices'), selected: _band == b, onSelected: (_) => setState(() => _band = b), selectedColor: AppColors.primarySoft, labelStyle: sinhalaText(11, weight: FontWeight.w800))).toList()),
    const SizedBox(height: 16), Text('Choose an avatar', style: sinhalaText(12, weight: FontWeight.w900)), const SizedBox(height: 8), Wrap(spacing: 10, runSpacing: 10, children: List.generate(kAvatars.length, (i) { final selected = _avatar == i; return InkWell(borderRadius: BorderRadius.circular(17), onTap: () => setState(() => _avatar = i), child: Container(width: 82, height: 88, decoration: BoxDecoration(color: selected ? AppColors.primarySoft : const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(17), border: Border.all(color: selected ? AppColors.primary : AppColors.line, width: selected ? 2.5 : 1)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(kAvatars[i], style: const TextStyle(fontSize: 32)), Text(kAvatarNames[i], style: sinhalaText(9.5, color: AppColors.inkSoft, weight: FontWeight.w800)), if (selected) const Icon(Icons.check_circle, color: AppColors.primary, size: 15)]))); })),
    const SizedBox(height: 22), Row(children: [Expanded(child: OutlinedButton(onPressed: widget.onCancel, child: const Text('Cancel'))), const SizedBox(width: 10), Expanded(flex: 2, child: ElevatedButton.icon(onPressed: _save, icon: const Icon(Icons.arrow_forward, size: 18), label: const Text('Save & Start Session')))]),
  ]))))));
}

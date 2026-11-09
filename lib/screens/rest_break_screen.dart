import 'dart:async';

import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/mascot_owl.dart';

/// Breathing break shown after two activities (rest-break prompt, NFR7.1).
class RestBreakScreen extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onFinish;
  const RestBreakScreen({
    super.key,
    required this.onContinue,
    required this.onFinish,
  });

  @override
  State<RestBreakScreen> createState() => _RestBreakScreenState();
}

class _RestBreakScreenState extends State<RestBreakScreen> {
  bool _in = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) setState(() => _in = !_in);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Rest & breathing break',
            style: sinhalaText(20, weight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            'Take a moment before the next activity.',
            style: sinhalaText(13, color: AppColors.inkSoft),
          ),
          const SizedBox(height: 28),
          AnimatedContainer(
            duration: const Duration(seconds: 4),
            curve: Curves.easeInOut,
            width: _in ? 220 : 140,
            height: _in ? 220 : 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primarySoft,
              border: Border.all(color: AppColors.primary, width: 4),
            ),
            alignment: Alignment.center,
            child: Text(
              _in ? 'හුස්ම ගන්න 🌬️' : 'පිට කරන්න 🍃',
              textAlign: TextAlign.center,
              style: sinhalaText(20, weight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 28),
          const MascotOwl(emotion: OwlEmotion.cheerful, size: 80),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onContinue,
              child: const Text('Continue screening activities'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: widget.onFinish,
              child: const Text('Finish session & view results'),
            ),
          ),
        ],
      ),
    );
  }
}

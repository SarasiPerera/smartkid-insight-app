import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/mascot_owl.dart';

/// Optional 30-second guided breathing pause suggested after two activities.
class RestBreakScreen extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onFinish;
  const RestBreakScreen({super.key, required this.onContinue, required this.onFinish});
  @override
  State<RestBreakScreen> createState() => _RestBreakScreenState();
}

class _RestBreakScreenState extends State<RestBreakScreen> {
  Timer? _timer;
  int _remaining = 30;
  int _phaseSeconds = 0;
  bool _inhale = true;
  bool _finished = false;

  @override
  void initState() { super.initState(); _timer = Timer.periodic(const Duration(seconds: 1), (_) { if (!mounted || _finished) return; setState(() { _remaining = (_remaining - 1).clamp(0, 30); _phaseSeconds++; if (_phaseSeconds >= 4) { _phaseSeconds = 0; _inhale = !_inhale; } if (_remaining == 0) _finished = true; }); }); }
  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Center(child: SingleChildScrollView(padding: const EdgeInsets.all(22), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 520), child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26), border: Border.all(color: const Color(0xFFBAE6FD))), child: Column(children: [
    const Icon(Icons.spa_outlined, color: Color(0xFF0284C7), size: 32), Text('Rest & Breathing Break', style: sinhalaText(21, weight: FontWeight.w900)), Text('Take a calm moment before the next activity.', style: sinhalaText(11.5, color: AppColors.inkSoft)),
    const SizedBox(height: 20), AnimatedContainer(duration: const Duration(seconds: 4), curve: Curves.easeInOut, width: _inhale ? 210 : 145, height: _inhale ? 210 : 145, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFE0F2FE), border: Border.all(color: const Color(0xFF38BDF8), width: 4)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(_finished ? 'හොඳයි! 🌟' : _inhale ? 'හුස්ම ගන්න' : 'පිට කරන්න', textAlign: TextAlign.center, style: sinhalaText(19, weight: FontWeight.w900, color: const Color(0xFF075985))), Text(_finished ? 'Complete' : '${_remaining}s', style: sinhalaText(15, color: const Color(0xFF0369A1), weight: FontWeight.w800))])),
    const SizedBox(height: 14), const MascotOwl(emotion: OwlEmotion.cheerful, size: 86, speech: 'අපි ටිකක් විවේක ගමු! 💙'), const SizedBox(height: 8), Text(_finished ? 'You are ready to continue.' : 'Breathe in slowly, then breathe out gently.', textAlign: TextAlign.center, style: sinhalaText(12, color: AppColors.inkSoft)),
    const SizedBox(height: 20), SizedBox(width: double.infinity, child: ElevatedButton(onPressed: widget.onContinue, child: const Text('Continue Screening Activities'))), const SizedBox(height: 9), SizedBox(width: double.infinity, child: OutlinedButton(onPressed: widget.onFinish, child: const Text('Finish Session & View Results'))),
  ])))));
}

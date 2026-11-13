import 'package:flutter/material.dart';
import '../services/tts_service.dart';
import '../theme.dart';
import '../widgets/mascot_owl.dart';

class WelcomeScreen extends StatefulWidget {
  final TtsService tts;
  final VoidCallback onContinue;
  const WelcomeScreen({super.key, required this.tts, required this.onContinue});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _soundMessage = 'Tap Test sound to hear the Sinhala greeting.';
  bool _testing = false;

  Future<void> _soundCheck() async {
    setState(() {
      _testing = true;
      _soundMessage = 'Testing your device Sinhala speech voice…';
    });
    final played = await widget.tts.speak(
      'ආයුබෝවන්! ස්මාර්ට්කිට් ඉන්සයිට් වෙත සාදරයෙන් පිළිගනිමු!',
    );
    if (!mounted) return;
    setState(() {
      _testing = false;
      _soundMessage = played
          ? 'Sinhala greeting sent to your device. If you cannot hear it, check media volume and the installed Sinhala voice.'
          : 'A Sinhala voice is not available yet. Enable or install Sinhala in your device text-to-speech settings, then try again.';
    });
  }

  @override
  Widget build(BuildContext context) => Center(child: SingleChildScrollView(padding: const EdgeInsets.all(18), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 540), child: Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), border: Border.all(color: const Color(0xFFFED7AA)), boxShadow: const [BoxShadow(color: Color(0x140F172A), blurRadius: 22, offset: Offset(0, 8))]), child: Column(children: [
    const MascotOwl(emotion: OwlEmotion.welcome, size: 128, speech: 'ආයුබෝවන්! මම ඔලී! 🦉'),
    const SizedBox(height: 8), Text('SmartKid Insight', style: sinhalaText(27, weight: FontWeight.w900)), Text('Sinhala Preschool Screening Platform', style: sinhalaText(12, color: AppColors.primary, weight: FontWeight.w800)),
    const SizedBox(height: 18),
    Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFFF7ED), border: Border.all(color: const Color(0xFFFED7AA)), borderRadius: BorderRadius.circular(18)), child: Row(children: [const Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 27), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Audio & Sound Permissions', style: sinhalaText(12, weight: FontWeight.w900, color: const Color(0xFF9A3412))), Text(_soundMessage, style: sinhalaText(10.5, color: const Color(0xFF9A3412)))])), const SizedBox(width: 5), FilledButton(style: FilledButton.styleFrom(backgroundColor: const Color(0xFF9A5B3C), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))), onPressed: _testing ? null : _soundCheck, child: Text(_testing ? 'Testing…' : 'Test sound'))])),
    const SizedBox(height: 14),
    Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFFF8FAFC), border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(18)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [const Icon(Icons.shield_outlined, color: Color(0xFF2563EB)), const SizedBox(width: 7), Text('Research Ethics & Child Privacy Notice', style: sinhalaText(12, weight: FontWeight.w900))]), const SizedBox(height: 9), _bullet('Anonymised identifiers', 'Children receive randomly generated IDs (e.g. KID-XXXXXXXX).'), _bullet('Local nicknames', 'Nicknames are stored on this device and are not uploaded to server logs.'), _bullet('Non-invasive screening', 'Tap-only, play-based screening activities for children aged 3–6. No voice, camera or handwriting is recorded.') ])),
    const SizedBox(height: 18), SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: widget.onContinue, icon: const Icon(Icons.arrow_forward), label: const Text('Continue to Screening'), style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)))),
  ])))));

  Widget _bullet(String title, String body) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('•  ', style: TextStyle(fontWeight: FontWeight.w900)), Expanded(child: RichText(text: TextSpan(style: sinhalaText(10.5, color: AppColors.inkSoft), children: [TextSpan(text: '$title: ', style: sinhalaText(10.5, weight: FontWeight.w900)), TextSpan(text: body)])))]));
}

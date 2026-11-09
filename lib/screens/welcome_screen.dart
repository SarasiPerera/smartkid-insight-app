import 'package:flutter/material.dart';

import '../services/tts_service.dart';
import '../theme.dart';
import '../widgets/mascot_owl.dart';

/// Includes a sound check. Many phones have no Sinhala voice installed, so the
/// screen tells the adult up front rather than letting audio fail silently.
class WelcomeScreen extends StatefulWidget {
  final TtsService tts;
  final VoidCallback onContinue;
  const WelcomeScreen({super.key, required this.tts, required this.onContinue});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool? _sinhalaOk;

  Future<void> _soundCheck() async {
    final ok = await widget.tts.sinhalaAvailable();
    if (mounted) setState(() => _sinhalaOk = ok);
    await widget.tts.speak(
      'ආයුබෝවන්! ස්මාර්ට්කිට් ඉන්සයිට් වෙත සාදරයෙන් පිළිගනිමු!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const MascotOwl(
            emotion: OwlEmotion.welcome,
            size: 120,
            speech: 'ආයුබෝවන්! මම ඔලී! 🦉',
          ),
          const SizedBox(height: 16),
          _card(
            title: '🔊 Audio & sound check',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Questions are read aloud in Sinhala. Turn the volume up, then tap the button to test.',
                  style: sinhalaText(13, color: AppColors.inkSoft),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _soundCheck,
                  child: const Text('🔊 Test sound'),
                ),
                if (_sinhalaOk == false) ...[
                  const SizedBox(height: 10),
                  Text(
                    'No Sinhala voice was found on this phone. Install or enable Sinhala in the phone\'s '
                    'Text-to-speech settings (Google Speech Services), otherwise questions will not be spoken.',
                    style: sinhalaText(
                      12,
                      color: AppColors.weak,
                      weight: FontWeight.w700,
                    ),
                  ),
                ],
                if (_sinhalaOk == true) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Sinhala voice found.',
                    style: sinhalaText(
                      12,
                      color: AppColors.strong,
                      weight: FontWeight.w800,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          _card(
            title: '🛡️ Research ethics & child privacy',
            child: Text(
              '• Children are identified only by anonymised IDs (e.g. KID-XXXXXXXX).\n'
              '• Nicknames are stored on this device only and are never uploaded.\n'
              '• All activities are tap-only screening games for ages 3–6. No voice, camera or handwriting is recorded.',
              style: sinhalaText(12.5, color: AppColors.inkSoft),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onContinue,
              child: const Text('Continue to screening'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required String title, required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: sinhalaText(14, weight: FontWeight.w800)),
        const SizedBox(height: 8),
        child,
      ],
    ),
  );
}

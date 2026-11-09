import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// On-device Sinhala speech through the phone's text-to-speech engine.
/// Android needs a Sinhala voice installed (Google Speech Services provides one);
/// [sinhalaAvailable] lets the UI warn the teacher during the sound check
/// instead of failing silently.
class TtsService {
  final FlutterTts _tts = FlutterTts();
  final ValueNotifier<bool> speaking = ValueNotifier(false);
  bool _ready = false;

  Future<void> _init() async {
    if (_ready) return;
    await _tts.setLanguage('si-LK');
    await _tts.setSpeechRate(0.4);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.1);
    _tts.setStartHandler(() => speaking.value = true);
    _tts.setCompletionHandler(() => speaking.value = false);
    _tts.setCancelHandler(() => speaking.value = false);
    _tts.setErrorHandler((_) => speaking.value = false);
    _ready = true;
  }

  Future<bool> sinhalaAvailable() async {
    try {
      await _init();
      final r = await _tts.isLanguageAvailable('si-LK');
      return r == true || r == 1;
    } catch (_) {
      return false;
    }
  }

  Future<void> speak(String text) async {
    try {
      await _init();
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {
      speaking.value = false; // narration is an aid, never a blocker
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
    speaking.value = false;
  }
}

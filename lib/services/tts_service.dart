import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Sinhala text-to-speech wrapper for Android, iOS and Flutter Web.
/// Voice availability differs by device/browser, so the app always attempts
/// speech and reports the result of the actual sound test instead of relying
/// only on a locale capability check.
class TtsService {
  final FlutterTts _tts = FlutterTts();
  final ValueNotifier<bool> speaking = ValueNotifier(false);
  bool _ready = false;

  Future<void> _init() async {
    if (_ready) return;
    _tts.setStartHandler(() => speaking.value = true);
    _tts.setCompletionHandler(() => speaking.value = false);
    _tts.setCancelHandler(() => speaking.value = false);
    _tts.setErrorHandler((_) => speaking.value = false);
    await _tts.setSpeechRate(0.42);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.05);
    _ready = true;
  }

  Future<bool> _setSinhalaLanguage() async {
    // Some TTS engines expose Sinhala as si, while others use the regional tag.
    for (final locale in ['si-LK', 'si']) {
      try {
        final result = await _tts.isLanguageAvailable(locale);
        if (result == true || result == 1) {
          await _tts.setLanguage(locale);
          return true;
        }
      } catch (_) {
        // Continue to the alternate Sinhala locale.
      }
    }
    // Still try the regional locale: some browser engines do not implement
    // isLanguageAvailable accurately but can resolve the voice when speaking.
    try {
      await _tts.setLanguage('si-LK');
    } catch (_) {
      return false;
    }
    return true;
  }

  Future<bool> sinhalaAvailable() async {
    try {
      await _init();
      for (final locale in ['si-LK', 'si']) {
        try {
          final result = await _tts.isLanguageAvailable(locale);
          if (result == true || result == 1) return true;
        } catch (_) {}
      }
      // Do not treat a missing capability-query result as proof that speech
      // cannot work; the real speak() test below is authoritative.
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> speak(String text) async {
    if (text.trim().isEmpty) return false;
    try {
      await _init();
      await _tts.stop();
      await _setSinhalaLanguage();
      final result = await _tts.speak(text);
      final success = result == 1 || result == true || result == null;
      if (!success) speaking.value = false;
      return success;
    } catch (_) {
      speaking.value = false;
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
    speaking.value = false;
  }
}

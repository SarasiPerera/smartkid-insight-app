
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Sinhala text-to-speech service for Android and Flutter Web.
class TtsService {
  final FlutterTts _tts = FlutterTts();

  final ValueNotifier<bool> speaking = ValueNotifier(false);

  bool _ready = false;
  

  Future<void> _init() async {
    if (_ready) return;

    _tts.setStartHandler(() {
      speaking.value = true;
      debugPrint('TTS: Speech started');
    });

    _tts.setCompletionHandler(() {
      speaking.value = false;
      debugPrint('TTS: Speech completed');
    });

    _tts.setCancelHandler(() {
      speaking.value = false;
      debugPrint('TTS: Speech cancelled');
    });

    _tts.setErrorHandler((message) {
      speaking.value = false;
      debugPrint('TTS ERROR: $message');
    });

    await _tts.setSpeechRate(0.42);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.05);

    _ready = true;
  }

  /// Finds a Sinhala voice exposed by the current platform.
  Future<bool> _selectSinhalaVoice() async {
    try {
      // Get the available system/browser voices.
      dynamic result = await _tts.getVoices;

      // Some browsers populate their voice list asynchronously.
      if (result is! List || result.isEmpty) {
        await Future.delayed(
          const Duration(milliseconds: 500),
        );
        result = await _tts.getVoices;
      }

      if (result is! List) {
        debugPrint('TTS: Voice list is unavailable.');
        return false;
      }

      debugPrint('TTS: Available voices:');

      for (final item in result) {
        if (item is! Map) continue;

        final name = item['name']?.toString() ?? '';
        final locale = item['locale']?.toString() ?? '';

        debugPrint('TTS VOICE: $name ($locale)');

        if (locale.toLowerCase().startsWith('si')) {
          await _tts.setVoice({
            'name': name,
            'locale': locale,
          });

          await _tts.setLanguage(locale);

          debugPrint('TTS: Selected Sinhala voice: $name ($locale)');

          
          return true;
        }
      }

      debugPrint('TTS: No Sinhala voice found in available voices.');

      // Try the regional Sinhala locale as a final fallback.
      for (final locale in ['si-LK', 'si']) {
        try {
          final available = await _tts.isLanguageAvailable(locale);

          if (available == true || available == 1) {
            await _tts.setLanguage(locale);
            debugPrint('TTS: Sinhala locale selected: $locale');

            
            return true;
          }
        } catch (e) {
          debugPrint('TTS: Could not check $locale: $e');
        }
      }

      
      return false;
    } catch (e) {
      debugPrint('TTS voice selection error: $e');
      return false;
    }
  }

  /// Checks whether Sinhala speech is available.
  Future<bool> sinhalaAvailable() async {
    try {
      await _init();
      return await _selectSinhalaVoice();
    } catch (e) {
      debugPrint('TTS availability error: $e');
      return false;
    }
  }

  /// Reads the supplied Sinhala question.
  Future<bool> speak(String text) async {
    if (text.trim().isEmpty) return false;

    try {
      await _init();

      // Stop the previous question before reading the next one.
      await _tts.stop();
      speaking.value = false;

      // Select the Sinhala voice before speaking.
      final available = await _selectSinhalaVoice();

      if (!available) {
        debugPrint(
          'TTS: Cannot read question because no Sinhala voice is available.',
        );
        return false;
      }

      debugPrint('TTS: Reading question: $text');

      final result = await _tts.speak(text);

      debugPrint('TTS: Speak result: $result');

      final success =
          result == 1 || result == true || result == null;

      if (!success) {
        speaking.value = false;
      }

      return success;
    } catch (e) {
      speaking.value = false;
      debugPrint('TTS SPEAK ERROR: $e');
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (e) {
      debugPrint('TTS stop error: $e');
    }

    speaking.value = false;
  }
}

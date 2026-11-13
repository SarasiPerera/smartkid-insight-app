
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundEffectService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playCorrect() async {
    try {
      await _player.stop();
      await _player.play(
        AssetSource('sounds/correct.wav'),
        volume: 0.8,
      );
    } catch (e) {
      debugPrint('Correct sound error: $e');
    }
  }

  Future<void> playIncorrect() async {
    try {
      await _player.stop();
      await _player.play(
        AssetSource('sounds/incorrect.wav'),
        volume: 0.65,
      );
    } catch (e) {
      debugPrint('Incorrect sound error: $e');
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}

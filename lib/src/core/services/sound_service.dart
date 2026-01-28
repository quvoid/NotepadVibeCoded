import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final soundServiceProvider = Provider((ref) => SoundService());

class SoundService {
  final AudioPlayer _player = AudioPlayer();

  // These will be the asset paths. 
  // You need to add these files to assets/sounds/
  static const String lightsaberOn = 'sounds/lightsaber_on.mp3';
  static const String lightsaberOff = 'sounds/lightsaber_off.mp3';
  static const String lightsaberHum = 'sounds/lightsaber_hum.mp3';
  static const String lightsaberClash = 'sounds/lightsaber_clash.mp3';
  static const String breathing = 'sounds/vader_breathing.mp3';

  Future<void> playLightsaberOn() async {
    try {
      await _player.stop();
      await _player.play(AssetSource(lightsaberOn));
    } catch (_) {
      // Ignore errors if assets are missing
    }
  }

  Future<void> playLightsaberOff() async {
    try {
      await _player.stop();
      await _player.play(AssetSource(lightsaberOff));
    } catch (_) {
      // Ignore errors
    }
  }

  Future<void> playClash() async {
    try {
      // Create a temporary player for overlapping sounds
      final tempPlayer = AudioPlayer();
      await tempPlayer.play(AssetSource(lightsaberClash));
      tempPlayer.onPlayerComplete.listen((_) => tempPlayer.dispose());
    } catch (_) {
      // Ignore errors
    }
  }

  Future<void> playBreathing() async {
    try {
      await _player.play(AssetSource(breathing));
    } catch (_) {
      // Ignore errors
    }
  }
}

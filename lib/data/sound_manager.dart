import 'package:audioplayers/audioplayers.dart';
import 'package:puzzlers/helpers/app_sounds.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;

  SoundManager._internal();

  final AudioPlayer _bgPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isBgPlaying = false;
  bool _isSoundEnabled = true;

  // Getter untuk cek status sound
  bool get isSoundEnabled => _isSoundEnabled;

  // Toggle sound on/off
  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;
    if (!_isSoundEnabled) {
      stopBackground();
    }
  }

  Future<void> playBackground() async {
    if (_isBgPlaying || !_isSoundEnabled) return;

    try {
      await _bgPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgPlayer.setVolume(0.3);
      await _bgPlayer.play(AssetSource(AppSounds.backSound));
      _isBgPlaying = true;
      print('✅ Background music started');
    } catch (e) {
      print('❌ Error playing background: $e');
    }
  }

  Future<void> stopBackground() async {
    try {
      await _bgPlayer.stop();
      _isBgPlaying = false;
      print('⏹️ Background music stopped');
    } catch (e) {
      print('❌ Error stopping background: $e');
    }
  }

  Future<void> pauseBackground() async {
    try {
      await _bgPlayer.pause();
      _isBgPlaying = false;
      print('⏸️ Background music paused');
    } catch (e) {
      print('❌ Error pausing background: $e');
    }
  }

  Future<void> resumeBackground() async {
    if (!_isSoundEnabled) return;

    try {
      await _bgPlayer.resume();
      _isBgPlaying = true;
      print('▶️ Background music resumed');
    } catch (e) {
      print('❌ Error resuming background: $e');
    }
  }

  Future<void> playClick() async {
    if (!_isSoundEnabled) return;

    try {
      // Stop dulu kalau masih playing
      await _sfxPlayer.stop();

      // Set mode dan volume
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      await _sfxPlayer.setVolume(1.0);

      // Play sound
      await _sfxPlayer.play(AssetSource(AppSounds.clickSound));
      print('🔊 Click sound played');
    } catch (e) {
      print('❌ Error playing click: $e');
    }
  }

  // Method untuk play sound lain (opsional)
  Future<void> playSound(String soundPath, {double volume = 1.0}) async {
    if (!_isSoundEnabled) return;

    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      await _sfxPlayer.setVolume(volume);
      await _sfxPlayer.play(AssetSource(soundPath));
      print('🔊 Sound played: $soundPath');
    } catch (e) {
      print('❌ Error playing sound: $e');
    }
  }

  void dispose() {
    _bgPlayer.dispose();
    _sfxPlayer.dispose();
    print('🗑️ Sound manager disposed');
  }
}


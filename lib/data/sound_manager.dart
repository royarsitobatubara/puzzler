import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:puzzlers/data/preferences.dart';
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
      debugPrint('✅ Background music started');
    } catch (e) {
      debugPrint('❌ Error playing background: $e');
    }
  }

  Future<void> stopBackground() async {
    try {
      await _bgPlayer.stop();
      _isBgPlaying = false;
      debugPrint('⏹️ Background music stopped');
    } catch (e) {
      debugPrint('❌ Error stopping background: $e');
    }
  }

  Future<void> pauseBackground() async {
    try {
      await _bgPlayer.pause();
      _isBgPlaying = false;
      debugPrint('⏸️ Background music paused');
    } catch (e) {
      debugPrint('❌ Error pausing background: $e');
    }
  }

  Future<void> resumeBackground() async {
    if (!_isSoundEnabled) return;

    try {
      await _bgPlayer.resume();
      _isBgPlaying = true;
      debugPrint('▶️ Background music resumed');
    } catch (e) {
      debugPrint('❌ Error resuming background: $e');
    }
  }

  Future<void> playClick() async {
    final isActive = await Preferences.getSoundEffect();

    if (!_isSoundEnabled || isActive == false) {
      return;
    }

    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      await _sfxPlayer.setVolume(1.0);

      await _sfxPlayer.play(AssetSource(AppSounds.clickSound));
      debugPrint('🔊 Click sound played');
    } catch (e) {
      debugPrint('❌ Error playing click: $e');
    }
  }


  // Method untuk play sound lain (opsional)
  Future<void> playSound(String soundPath, {double volume = 1.0}) async {
    final isActive = await Preferences.getSoundEffect();

    if (!_isSoundEnabled || isActive == false) {
      return;
    }

    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      await _sfxPlayer.setVolume(volume);
      await _sfxPlayer.play(AssetSource(soundPath));
      debugPrint('🔊 Sound played: $soundPath');
    } catch (e) {
      debugPrint('❌ Error playing sound: $e');
    }
  }

  void dispose() {
    _bgPlayer.dispose();
    _sfxPlayer.dispose();
    debugPrint('🗑️ Sound manager disposed');
  }
}


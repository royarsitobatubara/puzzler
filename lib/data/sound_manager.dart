import 'package:audioplayers/audioplayers.dart';
import 'package:puzzlers/helpers/app_sounds.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;

  SoundManager._internal();

  final AudioPlayer _bgPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isBgPlaying = false;

  Future<void> playBackground() async {
    if (_isBgPlaying) return;

    await _bgPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgPlayer.play(AssetSource(AppSounds.backSound), volume: 0.3);
    _isBgPlaying = true;
  }

  Future<void> stopBackground() async {
    await _bgPlayer.stop();
    _isBgPlaying = false;
  }

  Future<void> pauseBackground() async {
    await _bgPlayer.pause();
    _isBgPlaying = false;
  }

  Future<void> resumeBackground() async {
    await _bgPlayer.resume();
    _isBgPlaying = true;
  }

  Future<void> playClick() async {
    await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
    await _sfxPlayer.play(AssetSource(AppSounds.clickSound), volume: 1.0);
  }


  void dispose() {
    _bgPlayer.dispose();
    _sfxPlayer.dispose();
  }
}

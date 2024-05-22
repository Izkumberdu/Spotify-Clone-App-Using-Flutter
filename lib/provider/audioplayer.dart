import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lettersquared/provider/providers.dart';

class AudioHandler {
  late final AudioPlayer _audioPlayer;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  AudioHandler(WidgetRef ref) {
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
  }

  AudioPlayer get audioPlayer => _audioPlayer;

  void _initAudioPlayer() {
    _audioPlayer.positionStream.listen((newPosition) {
      position = newPosition;
    });

    _audioPlayer.durationStream.listen((newDuration) {
      duration = newDuration ?? Duration.zero;
    });
  }

  Future<void> setAudioSource(String url) async {
    await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));
  }

  Future<void> play(WidgetRef ref) async {
    await _audioPlayer.play();
  }

  Future<void> pause(WidgetRef ref) async {
    await _audioPlayer.pause();
  }

  Future<void> seek(WidgetRef ref, Duration newPosition) async {
    await _audioPlayer.seek(newPosition);
    position = newPosition;
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}

import 'package:audio_service/audio_service.dart';

class AudioPlayerData<T> {
  final T? audio;
  final List<T> queue;
  final PlaybackState playbackState;
  final Duration? currentAudioPosition;
  final Duration? currentAudioDuration;

  AudioPlayerData({
    this.audio,
    required this.queue,
    required this.playbackState,
    this.currentAudioPosition,
    this.currentAudioDuration,
  });
}

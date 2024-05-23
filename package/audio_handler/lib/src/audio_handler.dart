import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

Future<AudioHandler> initAudioService({
  required String androidNotificationChannelId,
  required String androidNotificationChannelName,
}) async {
  return await AudioService.init(
      builder: () => MyAudioHandler(),
      config: AudioServiceConfig(
        androidNotificationChannelId: androidNotificationChannelId,
        androidNotificationChannelName: androidNotificationChannelName,
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ));
}

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  final _queue = ConcatenatingAudioSource(children: []);
  MyAudioHandler() {
    _loadEmptyList();
  }

  @override
  Future<void> play() => _player.play();
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    final audioSource = AudioSource.uri(
        Uri.parse(mediaItem.extras!['songUrl'] as String),
        tag: mediaItem);
    _queue.add(audioSource);
    final newQueue = queue.value..add(mediaItem);
    queue.add(newQueue);
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    if (_queue.length > index) {
      _queue.removeAt(index);
      final newQueue = queue.value..removeAt(index);
      queue.add(newQueue);
    }
  }

  @override
  Future<void> _loadEmptyList() async {
    try {
      await _player.setAudioSource(_queue);
    } catch (err) {
      print('Error Loading empty Playlist: $err');
    }
  }
}

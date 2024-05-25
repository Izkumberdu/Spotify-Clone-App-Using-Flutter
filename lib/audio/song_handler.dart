import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class SongHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer audioPlayer = AudioPlayer();

  UriAudioSource _createAudioSource(MediaItem item) {
    final url = item.extras!['url'] as String;
    return ProgressiveAudioSource(Uri.parse(url));
  }

  void _listenForCurrentSongIndexChanges() {
    audioPlayer.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) {
        return;
      }
      mediaItem.add(playlist[index]);
    });
  }

  void _broadCastState(PlaybackEvent event) {
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        if (audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.completed: AudioProcessingState.completed,
        ProcessingState.ready: AudioProcessingState.ready,
      }[audioPlayer.processingState]!,
      playing: audioPlayer.playing,
      updatePosition: audioPlayer.position,
      bufferedPosition: audioPlayer.bufferedPosition,
      speed: audioPlayer.speed,
      queueIndex: event.currentIndex,
    ));
  }

  Future<void> initSongs(List<MediaItem> songs) async {
    audioPlayer.playbackEventStream.listen(_broadCastState);
    final audioSource = songs.map(_createAudioSource).toList();
    await audioPlayer
        .setAudioSource(ConcatenatingAudioSource(children: audioSource));
    queue.value.clear();
    queue.value.addAll(songs);
    queue.add(queue.value);
    _listenForCurrentSongIndexChanges();

    audioPlayer.processingStateStream.listen(
      (state) {
        if (state == ProcessingState.completed) {
          skipToNext();
        }
      },
    );
  }

  @override
  Future<void> play() => audioPlayer.play();

  @override
  Future<void> pause() => audioPlayer.pause();

  @override
  Future<void> seek(Duration position) => audioPlayer.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    await audioPlayer.seek(Duration.zero, index: index);
    play();
  }

  @override
  Future<void> skipToNext() async {
    final currentIndex = audioPlayer.currentIndex;
    final lastIndex = queue.value.length - 1;
    if (currentIndex == lastIndex) {
      await audioPlayer.seek(Duration.zero, index: 0);
    } else {
      await audioPlayer.seekToNext();
    }
    play();
  }

  @override
  Future<void> skipToPrevious() async {
    final currentIndex = audioPlayer.currentIndex;
    if (currentIndex == 0) {
      final lastIndex = queue.value.length - 1;
      await audioPlayer.seek(Duration.zero, index: lastIndex);
    } else {
      await audioPlayer.seekToPrevious();
    }
    play();
  }
}

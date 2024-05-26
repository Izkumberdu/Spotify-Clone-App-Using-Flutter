import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class SongHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer audioPlayer = AudioPlayer();
  final BehaviorSubject<bool> _shuffleModeSubject =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _loopModeSubject =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _isPlayingSubject =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _isDismissedSubject =
      BehaviorSubject<bool>.seeded(false);

  UriAudioSource _createAudioSource(MediaItem item) {
    final url = item.extras!['url'] as String;
    return ProgressiveAudioSource(Uri.parse(url));
  }

  void _listenForCurrentSongIndexChanges() {
    audioPlayer.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) {
        mediaItem.add(null);
        _isPlayingSubject.add(false);
      } else {
        mediaItem.add(playlist[index]);
        _isPlayingSubject.add(audioPlayer.playing);
      }
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
        MediaAction.setShuffleMode,
        MediaAction.setRepeatMode,
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
      shuffleMode: audioPlayer.shuffleModeEnabled
          ? AudioServiceShuffleMode.all
          : AudioServiceShuffleMode.none,
      repeatMode: audioPlayer.loopMode == LoopMode.one
          ? AudioServiceRepeatMode.one
          : AudioServiceRepeatMode.none,
    ));
    _shuffleModeSubject.add(audioPlayer.shuffleModeEnabled);
    _loopModeSubject.add(audioPlayer.loopMode == LoopMode.one);
    _isPlayingSubject.add(audioPlayer.playing);
  }

  Future<void> initSongs(List<MediaItem> songs) async {
    audioPlayer.playbackEventStream.listen(_broadCastState);
    final audioSource = songs.map(_createAudioSource).toList();
    await audioPlayer.setAudioSource(
        ConcatenatingAudioSource(children: audioSource),
        preload: false); // Preload but don't play
    queue.value.clear();
    queue.value.addAll(songs);
    queue.add(queue.value);
    _listenForCurrentSongIndexChanges();

    audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        if (audioPlayer.loopMode == LoopMode.one) {
          audioPlayer.seek(Duration.zero);
          play();
        } else {
          skipToNext();
        }
      }
    });
  }

  Future<void> toggleShuffle() async {
    final isShuffling = audioPlayer.shuffleModeEnabled;
    if (isShuffling) {
      await audioPlayer.setShuffleModeEnabled(false);
    } else {
      await audioPlayer.setShuffleModeEnabled(true);
      await audioPlayer.shuffle();
    }
    _broadCastState(audioPlayer.playbackEvent);
  }

  Future<void> toggleLoop() async {
    final isLooping = audioPlayer.loopMode == LoopMode.one;
    if (isLooping) {
      await audioPlayer.setLoopMode(LoopMode.off);
    } else {
      await audioPlayer.setLoopMode(LoopMode.one);
    }
    _loopModeSubject.add(audioPlayer.loopMode == LoopMode.one);
    _broadCastState(audioPlayer.playbackEvent);
  }

  Stream<bool> get shuffleModeStream => _shuffleModeSubject.stream;

  Stream<bool> get loopModeStream => _loopModeSubject.stream;

  Stream<bool> get isPlayingStream => _isPlayingSubject.stream;

  Stream<bool> get isDismissedStream => _isDismissedSubject.stream;

  @override
  Future<void> play() {
    _isPlayingSubject.add(true);
    _isDismissedSubject.add(false);
    return audioPlayer.play();
  }

  @override
  Future<void> pause() {
    _isPlayingSubject.add(false);
    return audioPlayer.pause();
  }

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

  Future<void> dismiss() async {
    _isDismissedSubject.add(true);
  }
}

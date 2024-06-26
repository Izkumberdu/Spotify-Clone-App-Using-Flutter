import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lettersquared/firebase/getSongs.dart';

//navbar provider
final navbarIndexProvider = StateProvider<int>((ref) => 1);

final getSongsProvider = FutureProvider<List<Song>>((ref) async {
  return GetSongs().fetchSongs();
});

final songIndexProvider = StateProvider<int>((ref) => 0);

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final audioPlayer = AudioPlayer();
  ref.onDispose(() {
    audioPlayer.dispose();
  });
  return audioPlayer;
});

final trackViewIsPlaying = StateProvider<bool>((ref) => false);
final musicTrackerIsPlaying = StateProvider<bool>((ref) => false);

final currentSongIndexProvider = StateProvider<int>((ref) => 0);

final currentSongProvider = StateProvider<Song?>((ref) {
  final songIndex = ref.watch(currentSongIndexProvider);
  final songList = ref.watch(songListProvider);
  return songList.isNotEmpty ? songList[songIndex] : null;
});

final lastDurationProvider = StateProvider<Duration>((ref) => Duration.zero);
final lastPositionProvider = StateProvider<Duration>((ref) => Duration.zero);

final songListProvider = StateProvider<List<Song>>((ref) => []);

final selectedCategoryProvider = StateProvider<String>((ref) => 'Playlists');

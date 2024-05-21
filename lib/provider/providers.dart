import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lettersquared/firebase/getSongs.dart';

//navbar provider
final navbarIndexProvider = StateProvider<int>((ref) => 1);

final getSongsProvider = FutureProvider<List<Song>>((ref) async {
  return GetSongs().fetchSongs();
});

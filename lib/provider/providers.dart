import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lettersquared/supabase/get_songs.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//navbar provider
final navbarIndexProvider = StateProvider<int>((ref) => 1);

final getSongsProvider = FutureProvider<List<Song>>((ref) async {
  final supabaseClient = ref.watch(supabaseClientProvider);
  final getSongs = GetSongs(supabaseClient);
  final songs = await getSongs.fetchSongs();

  return songs;
});

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  final supabaseClient = SupabaseClient(
    'https://ieczccbopoftaobhqmwz.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImllY3pjY2JvcG9mdGFvYmhxbXd6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTUwNzAwNTIsImV4cCI6MjAzMDY0NjA1Mn0.i3zdyASAic6SLr6IKbxTmcksu69Xb8zFb7n_Eg9w0UU',
  );

  return supabaseClient;
});

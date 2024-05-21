import 'package:supabase_flutter/supabase_flutter.dart';

class Song {
  final int id;
  final String name;
  final String url;
  final String artist;
  final String imageSource;

  Song({
    required this.id,
    required this.name,
    required this.url,
    required this.artist,
    required this.imageSource,
  });
}

class GetSongs {
  final SupabaseClient _client;

  GetSongs(this._client);

  Future<List<Song>> fetchSongs() async {
    final response = await _client.from('Song').select();

    final List<Song> songs = [];

    for (final row in response) {
      final song = Song(
        id: row['id'] as int,
        name: row['name'] as String,
        url: row['url'] as String,
        artist: row['artist'] as String,
        imageSource: row['image_source'] as String,
      );
      songs.add(song);
    }
    return songs;
  }
}

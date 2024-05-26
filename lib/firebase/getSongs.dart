import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lettersquared/audio/permissions.dart';

class Song {
  final String id;
  final String name;
  final String url;
  final String artist;
  final String imageSource;
  final String color;
  final int index;
  final bool isPlaying;

  Song(
      {required this.id,
      required this.name,
      required this.url,
      required this.color,
      required this.artist,
      required this.imageSource,
      required this.index,
      required this.isPlaying});

  factory Song.fromFirestore(DocumentSnapshot doc, int index) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Song(
      id: doc.id,
      name: data['Title'] ?? '',
      url: data['songUrl'] ?? '',
      color: data['Color'] ?? '',
      artist: data['Artist'] ?? '',
      imageSource: data['imageUrl'] ?? '',
      index: index,
      isPlaying: false,
    );
  }
}

class GetSongs {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Song>> fetchSongs() async {
    final QuerySnapshot result = await _firestore.collection('Songs').get();

    final List<Song> songs = result.docs.asMap().entries.map((entry) {
      int index = entry.key;
      DocumentSnapshot doc = entry.value;
      return Song.fromFirestore(doc, index);
    }).toList();

    return songs;
  }
}

Future<List<MediaItem>> getSongs() async {
  await requestSongsPermission();

  final player = AudioPlayer();

  GetSongs getSongs = GetSongs();
  List<Song> songsList = await getSongs.fetchSongs();

  List<MediaItem> songs = [];

  for (var song in songsList) {
    await player.setUrl(song.url);

    final duration = player.duration;

    songs.add(
      MediaItem(
        id: song.id,
        album: "", // Add album information if available
        title: song.name,
        artist: song.artist,
        genre: "", // Add genre information if available
        duration: duration,
        artUri: Uri.parse(song.imageSource),
        extras: {
          'url': song.url,
          'color': song.color,
          'index': song.index,
          'isPlaying': song.isPlaying
        },
      ),
    );
  }

  await player.dispose();

  return songs;
}

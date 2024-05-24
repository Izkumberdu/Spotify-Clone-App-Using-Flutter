import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Uncomment the Song class
class Song {
  final String id;
  final String name;
  final String url;
  final String artist;
  final String imageSource;
  final String color;

  Song({
    required this.id,
    required this.name,
    required this.url,
    required this.color,
    required this.artist,
    required this.imageSource,
  });

  factory Song.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Song(
      id: doc.id,
      name: data['Title'] ?? '',
      url: data['songUrl'] ?? '',
      color: data['Color'] ?? '',
      artist: data['Artist'] ?? '',
      imageSource: data['imageUrl'] ?? '',
    );
  }
}

class GetSongs {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Song>> fetchSongs() async {
    final QuerySnapshot result = await _firestore.collection('Songs').get();

    final List<Song> songs =
        result.docs.map((doc) => Song.fromFirestore(doc)).toList();

    return songs;
  }
}

Future<List<MediaItem>> getSongs() async {
  GetSongs getSongs = GetSongs();
  List<Song> songs = await getSongs.fetchSongs();

  List<MediaItem> mediaItems = songs.map((song) {
    return MediaItem(
      id: song.id,
      album: "", // Add album information if available
      title: song.name,
      artist: song.artist,
      genre: "", // Add genre information if available
      duration: Duration.zero, // Add duration if available
      artUri: Uri.parse(song.imageSource),
      extras: {
        'url': song.url,
        'color': song.color,
      },
    );
  }).toList();

  return mediaItems;
}

import 'package:cloud_firestore/cloud_firestore.dart';

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
    Map data = doc.data() as Map<String, dynamic>;
    return Song(
      id: doc.id,
      name: data['Title'] ?? '',
      url: data['songUrl'] ?? '',
      color: data['color'] ?? '',
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

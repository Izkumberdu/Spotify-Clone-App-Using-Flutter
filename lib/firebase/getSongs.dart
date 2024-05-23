import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lettersquared/models/songs.dart';

class GetSongs {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Song>> fetchSongs() async {
    final QuerySnapshot result = await _firestore.collection('Songs').get();
    final List<Song> songs =
        result.docs.map((doc) => Song.fromFirestore(doc)).toList();
    return songs;
  }
}

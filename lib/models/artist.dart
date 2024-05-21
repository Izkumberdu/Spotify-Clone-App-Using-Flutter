import 'package:cloud_firestore/cloud_firestore.dart';

class Artist {
  final String name;
  final String imageURL;

  Artist({
    required this.name,
    required this.imageURL
  });

  factory Artist.fromDocument(DocumentSnapshot doc) {
    return Artist(
      name: doc['name'],
      imageURL: doc['imageURL'],
    );
  }
}
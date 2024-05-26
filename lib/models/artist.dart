import 'package:cloud_firestore/cloud_firestore.dart';

class Artist {
  final String id;
  final String name;
  final String imageURL;

  Artist({
    required this.id,
    required this.name,
    required this.imageURL,
  });

  factory Artist.fromDocument(DocumentSnapshot doc) {
    return Artist(
      id: doc.id,
      name: doc['name'],
      imageURL: doc['imageURL'],
    );
  }
}

import 'package:flutter/material.dart';

class Song {
  final String title;
  final Color color;
  final String imagePath;
  final String artist;
  final String album;
  Song(
      {required this.title,
      required this.color,
      required this.imagePath,
      required this.artist,
      required this.album});
}

final List<Song> genres = [];

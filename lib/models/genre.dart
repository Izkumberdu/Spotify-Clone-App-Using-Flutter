import 'package:flutter/material.dart';

class Genre {
  final String title;
  final Color color;
  final String imagePath;

  Genre({
    required this.title,
    required this.color,
    required this.imagePath,
  });
}

final List<Genre> genres = [
  Genre(
    title: 'Pop',
    color: const Color(0xff9854B2),
    imagePath: 'assets/images/genreImages/pop.png',
  ),
  Genre(
    title: 'Indie',
    color: const Color(0xFF678026),
    imagePath: 'assets/images/genreImages/indie.jpg',
  ),
  Genre(
    title: 'Rock',
    color: const Color(0xFF4A4A4A),
    imagePath: 'assets/images/genreImages/rock.jpg',
  ),
  Genre(
    title: 'Hip-Hop',
    color: const Color(0xFFD35400),
    imagePath: 'assets/images/genreImages/hip-hop.png',
  ),
  Genre(
    title: 'Electronic',
    color: const Color(0xFF1E90FF),
    imagePath: 'assets/images/genreImages/electronic.jpg',
  ),
];

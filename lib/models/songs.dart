import 'package:audio_service/audio_service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@JsonSerializable()
class Song {
  final String id;
  final String title;
  final String url;
  final String artist;
  final String imageSource;
  final String color;
  final String albumId;
  final int playCount;
  final Duration duration;
  final bool isExplicit;

  const Song({
    required this.id,
    required this.title,
    required this.url,
    required this.artist,
    required this.imageSource,
    required this.color,
    required this.albumId,
    required this.playCount,
    required this.duration,
    required this.isExplicit,
  });

  factory Song.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Song(
      id: doc.id,
      title: data['Title'] ?? '',
      url: data['songUrl'] ?? '',
      artist: data['Artist'] ?? '',
      imageSource: data['imageUrl'] ?? '',
      color: data['Color'] ?? '',
      albumId: data['albumId'] ?? '',
      playCount: data['playCount'] ?? 0,
      duration: Duration(milliseconds: data['duration'] ?? 0),
      isExplicit: data['isExplicit'] ?? false,
    );
  }

  factory Song.fromMediaItem(MediaItem mediaItem) {
    try {
      return Song(
        id: mediaItem.id,
        albumId: mediaItem.album ?? '',
        artist: mediaItem.artist ?? '',
        title: mediaItem.title,
        url: mediaItem.extras!['audioUrl'] as String,
        playCount: mediaItem.extras!['playCount'] as int? ?? 0,
        isExplicit: mediaItem.extras!['isExplicit'] as bool? ?? false,
        duration: mediaItem.duration ?? Duration.zero,
        imageSource: '', // Assuming imageSource is not part of MediaItem
        color: '', // Assuming color is not part of MediaItem
      );
    } catch (err) {
      throw Exception('Failed to convert MediaItem to Song: $err');
    }
  }

  MediaItem toMediaItem() {
    return MediaItem(
      id: id,
      album: albumId,
      artist: artist,
      title: title,
      duration: duration,
      extras: <String, dynamic>{
        'audioUrl': url,
        'playCount': playCount,
        'isExplicit': isExplicit,
      },
    );
  }
}

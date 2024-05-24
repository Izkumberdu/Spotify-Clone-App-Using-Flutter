import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:lettersquared/audio/song_handler.dart';
import 'package:lettersquared/firebase/getSongs.dart';

class SongProvider extends ChangeNotifier {
  List<MediaItem> _songs = [];

  List<MediaItem> get songs => _songs;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  Future<void> loadSongs(SongHandler songHandler) async {
    _songs = await getSongs();

    await songHandler.initSongs(songs);

    _isLoading = false;

    notifyListeners();
  }
}

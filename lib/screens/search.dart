import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lettersquared/audio/song_handler.dart';
import 'package:lettersquared/components/playerDeck.dart';
import 'package:lettersquared/components/songContainer.dart';
import 'package:lettersquared/firebase/getSongs.dart';
import 'package:lettersquared/provider/song_provider.dart';
import 'package:lettersquared/styles/app_styles.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  SongHandler songHandler;
  SearchScreen({Key? key, required this.songHandler}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<MediaItem> result = [];
  final TextEditingController _textEditingController = TextEditingController();

  void _search({required String value, required List<MediaItem> songs}) {
    for (var i = 0; i < songs.length; i++) {
      var song = songs[i];
      bool containsTitle = song.title
          .toLowerCase()
          .replaceAll(" ", "")
          .contains(value.toLowerCase().replaceAll(" ", ""));
      bool containsArtist = song.artist!
          .toLowerCase()
          .replaceAll(" ", "")
          .contains(value.toLowerCase().replaceAll(" ", ""));

      if (containsTitle || containsArtist) {
        bool contains = result.any((element) => element.id == song.id);
        if (!contains) {
          setState(() {
            // Store the searched song directly
            result.add(song);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SongProvider>(
      builder: (context, ref, child) {
        List<MediaItem> songs = ref.songs;
        return Scaffold(
          backgroundColor: kBlack,
          appBar: AppBar(
            title: TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
              ),
              onChanged: (value) {
                setState(() {
                  result.clear();
                });
                _search(value: value, songs: songs);
              },
            ),
            actions: [
              if (_textEditingController.text.trim().isNotEmpty)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _textEditingController.clear();
                      result.clear();
                    });
                  },
                  icon: const Icon(Icons.close),
                ),
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: result.length,
                      itemBuilder: (context, index) {
                        final MediaItem mediaItem = result[index];
                        final Song song = Song(
                          id: mediaItem.id,
                          url: mediaItem.extras?['url'],
                          color: mediaItem.extras?['color'],
                          name: mediaItem.title ?? '',
                          artist: mediaItem.artist ?? '',
                          imageSource: mediaItem.artUri?.toString() ?? '',
                          index: mediaItem.extras?['index'],
                          isPlaying: mediaItem.extras?['isPlaying'],
                        );
                        return searchedSongsList(
                            context, song, widget.songHandler);
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: PlayerDeck(
                  songHandler: widget.songHandler,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget searchedSongsList(
      BuildContext context, Song song, SongHandler songHandler) {
    return GestureDetector(
      onTap: () {
        songHandler.skipToQueueItem(song.index);
      },
      child: Container(
        width: 393,
        height: 50,
        color: kBlack,
        child: Row(
          children: [
            Image.network(
              song.imageSource,
              height: 50,
              width: 50,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.name,
                  style: SenSemiBold.copyWith(fontSize: 16, color: kWhite),
                ),
                const SizedBox(height: 5),
                Text(
                  song.artist,
                  style: SenSemiBold.copyWith(fontSize: 12, color: kGrey),
                ),
              ],
            ),
            const Spacer(),
            StreamBuilder<MediaItem?>(
              stream: songHandler.mediaItem,
              builder: (context, snapshot) {
                final currentSong = snapshot.data;
                final isPlaying =
                    currentSong != null && currentSong.id == song.id;
                return IconButton(
                  icon: isPlaying
                      ? Icon(
                          Icons.pause_rounded,
                          size: 24,
                          color: kWhite,
                        )
                      : Icon(
                          Icons.play_arrow_rounded,
                          size: 24,
                          color: kWhite,
                        ),
                  onPressed: () {
                    if (isPlaying) {
                      songHandler.pause();
                    } else {
                      songHandler.skipToQueueItem(song.index);
                    }
                  },
                );
              },
            ),
            const SizedBox(width: 15),
            Image.asset('assets/images/icons/Heart_Solid.png'),
            const SizedBox(width: 10),
            Image.asset('assets/images/icons/more.png'),
          ],
        ),
      ),
    );
  }
}

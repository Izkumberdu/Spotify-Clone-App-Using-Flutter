import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lettersquared/audio/song_handler.dart';
import 'package:lettersquared/firebase/getSongs.dart';
import 'package:lettersquared/styles/app_styles.dart';

class SongList extends StatelessWidget {
  final SongHandler songHandler;
  const SongList({Key? key, required this.songHandler});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Song>>(
      future: _fetchSongs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final songs = snapshot.data!;
          final totalPages = (songs.length / 4).ceil();
          return PageView.builder(
            itemCount: totalPages,
            itemBuilder: (context, pageIndex) {
              final startIndex = pageIndex * 4;
              final endIndex = (startIndex + 4).clamp(0, songs.length);
              final pageSongs = songs.sublist(startIndex, endIndex);
              return ListView.builder(
                itemCount: pageSongs.length,
                itemBuilder: (context, index) {
                  final song = pageSongs[index];
                  return _buildSongContainer(
                      context, song, startIndex + index, songs);
                },
              );
            },
          );
        } else {
          return const Text('No songs available');
        }
      },
    );
  }

  Future<List<Song>> _fetchSongs() async {
    GetSongs getSongs = GetSongs();
    return await getSongs.fetchSongs();
  }

  Widget _buildSongContainer(
      BuildContext context, Song song, int index, List<Song> songs) {
    return StreamBuilder<MediaItem?>(
      stream: songHandler.mediaItem,
      builder: (context, snapshot) {
        final currentSong = snapshot.data;
        final isPlaying = currentSong != null && currentSong.id == song.id;
        return GestureDetector(
          onTap: () {
            songHandler.skipToQueueItem(index);
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
                IconButton(
                  icon: isPlaying
                      ? const Icon(
                          Icons.pause_rounded,
                          size: 24,
                          color: kWhite,
                        )
                      : const Icon(
                          Icons.play_arrow_rounded,
                          size: 24,
                          color: kWhite,
                        ),
                  onPressed: () {
                    if (isPlaying) {
                      songHandler.pause();
                    } else {
                      songHandler.skipToQueueItem(index);
                    }
                  },
                ),
                const SizedBox(width: 15),
                Image.asset('assets/images/icons/Heart_Solid.png'),
                const SizedBox(width: 10),
                    PopupMenuButton<String>(
                      color: kBlack,
                      onSelected: (String value) {
                        // Handle the selected option
                        switch (value) {
                          case 'like':
                            // Handle 'Like' option
                            break;
                          case 'add_to_playlist':
                            // Handle 'Add to playlist' option
                            break;
                          case 'go_to_queue':
                            Navigator.pushNamed(context, '/playingqueue'); // Navigate to '/playingqueue' route
                            break;
                          case 'add_to_queue':
                            // Handle 'Add to queue' option
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        _buildPopupMenuItem('Like', Icons.favorite),
                        _buildPopupMenuItem('Add to playlist', Icons.add),
                        _buildPopupMenuItem('Add to queue', Icons.playlist_add),
                        _buildPopupMenuItem('Go to queue', Icons.queue_play_next),
                      ],
                      child: Image.asset('assets/images/icons/more.png'),
                    )
              ],
            ),
          ),
        );
      },
    );
  }
}

PopupMenuItem<String> _buildPopupMenuItem(String text, IconData icon) {
  return PopupMenuItem<String>(
    value: text.toLowerCase().replaceAll(' ', '_'), 
    child: SizedBox(
      width: 105, 
      height: 30, 
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20), 
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.sen(color: Colors.white, fontSize: 10), 
          ),
        ],
      ),
    ),
  );
}

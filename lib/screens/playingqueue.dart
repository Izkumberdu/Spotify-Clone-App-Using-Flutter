import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lettersquared/audio/song_handler.dart';

class AlbumQueuePage extends StatefulWidget {
  final SongHandler songHandler;

  const AlbumQueuePage({Key? key, required this.songHandler}) : super(key: key);

  @override
  State<AlbumQueuePage> createState() => _AlbumQueuePageState();
}

class _AlbumQueuePageState extends State<AlbumQueuePage> {
  late List<bool> _isSelected;

  @override
  void initState() {
    super.initState();
    // Initialize _isSelected list with the same length as the queue
    _isSelected = List.generate(widget.songHandler.queue.value.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          color: const Color(0xFF121212),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: Column(
              children: [
                albumName(),
                const Spacer(),
                nowPlayingText(),
                const Spacer(),
                currentSong(),
                const Spacer(),
                nextQueue(),
                const Spacer(),
                queueList(context, widget.songHandler.queue.value),
                const Spacer(),
                songControls(),
                const Spacer(),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget queueList(BuildContext context, List<MediaItem> queue) {
  return SizedBox(
    width: 400,
    height: 500,
    child: ReorderableListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        for (int i = 0; i < queue.length; i++)
          _buildSongTile(context, queue[i], i),
      ],
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = widget.songHandler.queue.value.removeAt(oldIndex);
          widget.songHandler.queue.value.insert(newIndex, item);

          // Reorder the selection state as well
          final isSelectedItem = _isSelected.removeAt(oldIndex);
          _isSelected.insert(newIndex, isSelectedItem);
        });
      },
    ),
  );
}


  Widget _buildSongTile(BuildContext context, MediaItem song, int index) {
    return ListTile(
      key: Key('$index'),
      leading: Checkbox(
        value: _isSelected[index],
        onChanged: (bool? value) {
          setState(() {
            _isSelected[index] = value ?? false;
          });
        },
        shape: const CircleBorder(),
        checkColor: const Color(0xFF1ED760),
        fillColor: MaterialStateProperty.all(const Color(0xFF1B1818)),
        side: const BorderSide(
          color: Color(0xFFB3B3B3),
          width: 1.5,
        ),
      ),
      title: Text(
        song.title ?? 'Unknown Title',
        style: GoogleFonts.sen(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        song.artist ?? 'Unknown Artist',
        style: GoogleFonts.sen(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      tileColor: Colors.grey,
      onTap: () {
        setState(() {
          _isSelected[index] = !_isSelected[index];
        });
      },
    );
  }

  SizedBox songControls() {
    return SizedBox(
                width: 346,
                height: 87,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.shuffle,
                        size: 32, // Adjust the size of the icon
                        color: Color(0xFF1ED760)
                      ),
                      onPressed: () {
                        // Add shuffle button onPressed logic here
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.skip_previous,
                        size: 32,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Add back button onPressed logic here
                      },
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white, // Adjust circle background color as needed
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.play_arrow,
                          size: 32,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Add play/pause button onPressed logic here
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.skip_next,
                        size: 32,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Add forward button onPressed logic here
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.repeat,
                        size: 32,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Add repeat button onPressed logic here
                      },
                    ),
                  ],
                ),
              );
  }

Row nextQueue() {
  return Row(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Next on music queue:',
          style: GoogleFonts.sen(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
      const Spacer(), // Add space to push delete icon to the right
GestureDetector(
  onLongPress: () {
    setState(() {
      widget.songHandler.clearQueue();
      _isSelected = List.filled(widget.songHandler.queue.value.length, false);
    });
  },
  child: IconButton(
    icon: Icon(Icons.delete),
    onPressed: () {
      // Your onPressed logic here
      setState(() {
        for (int i = _isSelected.length - 1; i >= 0; i--) {
          if (_isSelected[i]) {
            widget.songHandler.queue.value.removeAt(i);
            _isSelected.removeAt(i);
          }
        }
      });
    },
    color: _isSelected.contains(true) ? Colors.green : Colors.white,
  ),
),





    ],
  );
}

SizedBox currentSong() {
  return SizedBox(
    child: StreamBuilder<MediaItem?>(
      stream: widget.songHandler.mediaItem,
      builder: (context, snapshot) {
        final playingSong = snapshot.data;
        if (playingSong == null) {
          return const SizedBox.shrink(); // Hide the widget if no song is playing
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 44, 54, 41), // Change color as needed
                  borderRadius: BorderRadius.circular(4)
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playingSong.title ?? 'Unknown Title',
                    style: GoogleFonts.sen(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: const Color(0xFF1ED760)
                    ),                   
                  ),
                  Text(
                    playingSong.artist ?? 'Unknown Artist',
                    style: GoogleFonts.sen(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: const Color(0xFFB3B3B3)
                    ),                   
                  ),
                ],
              ),
              const Spacer()
            ],
          );
        }
      },
    ),
  );
}


  Align nowPlayingText() {
    return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                          'Now Playing',
                          style: GoogleFonts.sen(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.white
                          )                  
                        ),
              );
  }

  SizedBox albumName() {
    return SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 16,
                        backgroundImage: AssetImage('assets/images/icons/logo.png'), // Replace with your image asset
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 200,
                      child: Text(
                        'Spotify Quick Picks',
                        style: GoogleFonts.sen(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white
                        ),                   
                        softWrap: true, // Enable text wrapping
                        maxLines: 2, // Set the maximum number of lines before wrapping
                      ),
                    ),
                    const Spacer()
                  ],
                )
              );
  }

}

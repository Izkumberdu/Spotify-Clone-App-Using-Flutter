import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlbumQueuePage extends StatefulWidget {
  const AlbumQueuePage({super.key});

  @override
  State<AlbumQueuePage> createState() => _AlbumQueuePageState();
}

class _AlbumQueuePageState extends State<AlbumQueuePage> {
  final List<bool> _isSelected = List.generate(10, (index) => false);
  @override
  Widget build(BuildContext context) {
    // Get the dimensions of the screen
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // Set width and height to screen dimensions
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
                queueList(context),
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

  SizedBox queueList(BuildContext context) {
    return SizedBox(
                width: 400,
                height: 500,
                child: ReorderableListView(
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    for (int i = 0; i < 10; i++)
                      _buildSongTile(context, i),
                  ],
                  
                  onReorder: (oldIndex, newIndex) {
                    // Callback when an item is reordered
                    // Implement logic to update the order of songs in the queue
                  },
                ),
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

  Align nextQueue() {
    return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                          'Next From: From Me to You - Mono / Remastered',
                          style: GoogleFonts.sen(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.white
                          )                  
                        ),
              );
  }

  SizedBox currentSong() {
    return SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.orange, // Change color as needed
                        borderRadius: BorderRadius.circular(4)
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                        'From Me to You - Mono / Remastered',
                        style: GoogleFonts.sen(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: const Color(0xFF1ED760)
                        ),                   
                      ),
                      Text(
                        'Washed Out',
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
                )
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
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue, // Change color as needed
                      ),
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage('assets/images/genreImages/electronic.jpg'), // Replace with your image asset
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 230,
                      child: Text(
                        'Album radio based on From Me to You - Mono / Remastered',
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
  
  Widget _buildSongTile(BuildContext context, int index) {
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
                        'Song $index',
                        style: GoogleFonts.sen(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.white
        ),
      ),
      subtitle: const Text('Artist name'),
      tileColor: Colors.grey,
      onTap: () {
        setState(() {
          _isSelected[index] = !_isSelected[index]; 
        });
      },
    );
  }



}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lettersquared/audio/song_handler.dart';
import 'package:lettersquared/components/playerDeck.dart';
import 'package:lettersquared/services/firebase_auth.dart';
import 'package:lettersquared/styles/app_styles.dart';

class LikedSongs extends StatefulWidget {
  SongHandler songHandler;
  LikedSongs({super.key, required this.songHandler});

  @override
  State<LikedSongs> createState() => _LikedSongsState();
}

class _LikedSongsState extends State<LikedSongs> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _authService = FirebaseAuthService();
  List<Map<String, dynamic>> likedSongs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLikedSongs();
  }

  Future<void> fetchLikedSongs() async {
    try {
      String? userId = _authService.getCurrentUserId();
      if (userId != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userId).get();
        List<dynamic> likedSongIds = userDoc['liked_songs'] ?? [];

        List<Map<String, dynamic>> songs = [];
        for (String songId in likedSongIds) {
          DocumentSnapshot songDoc =
              await _firestore.collection('Songs').doc(songId).get();
          if (songDoc.exists) {
            songs.add(songDoc.data() as Map<String, dynamic>);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Song not found: $songId')),
            );
          }
        }

        setState(() {
          likedSongs = songs;
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user is currently signed in.')),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching liked songs: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: Stack(
        children: [
          const FractionallySizedBox(
            heightFactor: 0.48,
            widthFactor: 1.0,
            child: GradientBackground(),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Liked Songs",
                        style: SenBold.copyWith(fontSize: 24, color: kWhite),
                      ),
                      Text(
                        "${likedSongs.length} songs",
                        style:
                            SenMedium.copyWith(fontSize: 12, color: kLightGrey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Image.asset(
                          "assets/images/icons/download-outline.png"),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset("assets/images/icons/Shuffle.png"),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset("assets/images/icons/pause.png"),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: ListView.builder(
                          itemCount: likedSongs.length,
                          itemBuilder: (context, index) {
                            final song = likedSongs[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Image.network(song['imageUrl']),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        song['Title'],
                                        style: SenBold.copyWith(
                                            fontSize: 16, color: kWhite),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        song['Artist'],
                                        style: SenMedium.copyWith(
                                            fontSize: 12, color: kLightGrey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
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
  }
}

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.center,
          colors: [
            Color.fromARGB(255, 11, 109, 255),
            kBlack,
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lettersquared/audio/song_handler.dart';
import 'package:lettersquared/components/bottomNavbar.dart';
import 'package:lettersquared/components/playerDeck.dart';
import 'package:lettersquared/components/songList.dart';
import 'package:lettersquared/models/genre.dart';
import 'package:lettersquared/provider/navbarProvider.dart';
import 'package:lettersquared/provider/song_provider.dart';
import 'package:lettersquared/services/firebase_auth.dart'; // Import FirebaseAuthService
import 'package:lettersquared/styles/app_styles.dart';
import 'package:provider/provider.dart';

class SearchMenu extends StatefulWidget {
  final SongHandler songHandler;
  const SearchMenu({super.key, required this.songHandler});

  @override
  _SearchMenuState createState() => _SearchMenuState();
}

class _SearchMenuState extends State<SearchMenu> {
  int _navbarIndex = 1;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<void> _addToLikedSongs(String songId) async {
    try {
      String? userId = _authService.getCurrentUserId();
      if (userId != null) {
        DocumentReference userDoc = _firestore.collection('users').doc(userId);
        await userDoc.update({
          'liked_songs': FieldValue.arrayUnion([songId])
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Song added to liked songs')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user is currently signed in.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding song to liked songs: $e')),
      );
    }
  }
  
  Future<void> _removeFromLikedSongs(String songId) async {
    try {
      String? userId = _authService.getCurrentUserId();
      if (userId != null) {
        DocumentReference userDoc = _firestore.collection('users').doc(userId);
        await userDoc.update({
          'liked_songs': FieldValue.arrayRemove([songId])
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Song removed from liked songs')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user is currently signed in.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing song from liked songs: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SongProvider>(builder: (context, ref, child) {
      return Scaffold(
        backgroundColor: kBlack,
        body: ref.isLoading
            ? _buildLoadingIndicator()
            : Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 26),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Search',
                              style:
                                  SenBold.copyWith(fontSize: 25, color: kWhite),
                            ),
                            Image.asset('assets/images/icons/camera.png'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        searchBar(context),
                        const SizedBox(height: 25),
                        Text(
                          "Your Top Genres",
                          textAlign: TextAlign.left,
                          style: SenSemiBold.copyWith(
                            fontSize: 18,
                            color: kWhite,
                          ),
                        ),
                        const SizedBox(height: 19),
                        Container(
                          height: 138,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: genres.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: categoryContainer(
                                  genres[index].title,
                                  genres[index].imagePath,
                                  genres[index].color,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quick Picks',
                              textAlign: TextAlign.left,
                              style: SenSemiBold.copyWith(
                                fontSize: 18,
                                color: kWhite,
                              ),
                            ),
                            Image.asset('assets/images/icons/Shuffle.png'),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: SongList(
                            songHandler: widget.songHandler,
                            addToLikedSongs: _addToLikedSongs,
                            removeFromLikedSongs: _removeFromLikedSongs,
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
        bottomNavigationBar: BotNavBar(
          currentIndex: _navbarIndex,
          onTap: (index) {
            setState(() {
              context
                  .read<NavbarProvider>()
                  .changeIndex(newIndex: _navbarIndex);
            });
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/homepage');
                break;
              case 1:
                Navigator.pushNamed(context, '/searchMenu');
                break;
              case 2:
                Navigator.pushNamed(context, '/library');
                break;
            }
          },
        ),
      );
    });
  }

  Widget searchBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/search');
      },
      child: Container(
        width: 393,
        height: 46,
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Image.asset('assets/images/icons/search.png'),
              const SizedBox(width: 10),
              Text(
                'Artist, Songs, Podcasts',
                style: SenMedium.copyWith(fontSize: 16, color: kBlack),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryContainer(String text, String imagePath, Color color) {
    return Container(
      width: 192,
      height: 109,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black45.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Transform.rotate(
              angle: 0.1,
              child: Image.asset(
                imagePath,
                height: 80,
                width: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        strokeCap: StrokeCap.round,
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lettersquared/components/bottomNavbar.dart';
import 'package:lettersquared/components/cards.dart';
import 'package:lettersquared/components/recently_played_item.dart';
import 'package:lettersquared/styles/app_styles.dart';
import 'package:lettersquared/provider/providers.dart';

class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  Future<List<Map<String, dynamic>>> _fetchRecentlyPlayed() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user logged in");
    }
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recently_played')
        .get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> _fetchFavoriteArtists() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user logged in");
    }
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    List<dynamic> favoriteArtistIds = userDoc['favorite_artists'] ?? [];
    if (favoriteArtistIds.isEmpty) {
      return [];
    }

    List<Map<String, dynamic>> favoriteArtists = [];
    for (String artistId in favoriteArtistIds) {
      DocumentSnapshot artistDoc = await FirebaseFirestore.instance
          .collection('artists')
          .doc(artistId)
          .get();
      favoriteArtists.add(artistDoc.data() as Map<String, dynamic>);
    }

    return favoriteArtists;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarIndex = ref.watch(navbarIndexProvider);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchRecentlyPlayed(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        List<Map<String, dynamic>> recentlyPlayedItems = snapshot.data ?? [];

        return Scaffold(
          backgroundColor: kBlack,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: kGreen),
                        child: Center(
                          child: Text(
                            "T",
                            style:
                                SenMedium.copyWith(fontSize: 20, color: kWhite),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Image.asset(
                                "assets/images/icons/notification.png"),
                          ),
                          const SizedBox(width: 22),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Image.asset(
                                "assets/images/icons/orientation lock.png"),
                          ),
                          const SizedBox(width: 22),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child:
                                Image.asset("assets/images/icons/Settings.png"),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Column(
                    children: [
                      Row(
                        children: [
                          CustomContainer(
                            imagePath: "assets/images/genreImages/rock.jpg",
                            text: "Liked Songs",
                            isLikedSongs: true,
                          ),
                          SizedBox(width: 12),
                          CustomContainer(
                            imagePath: "assets/images/genreImages/rock.jpg",
                            text: "Liked Songs",
                            isLikedSongs: true,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          CustomContainer(
                            imagePath: "assets/images/genreImages/rock.jpg",
                            text: "Liked Songs",
                            isLikedSongs: true,
                          ),
                          SizedBox(width: 12),
                          CustomContainer(
                            imagePath: "assets/images/genreImages/rock.jpg",
                            text: "Liked Songs",
                            isLikedSongs: true,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          CustomContainer(
                            imagePath: "assets/images/genreImages/rock.jpg",
                            text: "Liked Songs",
                            isLikedSongs: true,
                          ),
                          SizedBox(width: 12),
                          CustomContainer(
                            imagePath: "assets/images/genreImages/rock.jpg",
                            text: "Liked Songs",
                            isLikedSongs: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recently Played",
                        style: SenBold.copyWith(fontSize: 19, color: kWhite),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  recentlyPlayedItems.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.red,
                          child: const Text(
                            'No recently played items found',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var i = 0;
                                  i < recentlyPlayedItems.length;
                                  i++) ...[
                                RecentlyPlayedItem(
                                  height: 106,
                                  width: 106,
                                  imageUrl:
                                      recentlyPlayedItems[i]['imageUrl'] ?? '',
                                  isArtist:
                                      recentlyPlayedItems[i]['artist'] ?? false,
                                  name: recentlyPlayedItems[i]['name'] ?? '',
                                ),
                                if (i < recentlyPlayedItems.length - 1)
                                  const SizedBox(width: 20),
                              ],
                            ],
                          ),
                        ),
                  const SizedBox(height: 12),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchFavoriteArtists(),
                    builder: (context, favSnapshot) {
                      if (favSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (favSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${favSnapshot.error}'));
                      }
                      if (!favSnapshot.hasData || favSnapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No favorite artists found'));
                      }

                      List<Map<String, dynamic>> favoriteArtists =
                          favSnapshot.data!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Favorite Artists",
                            style:
                                SenBold.copyWith(fontSize: 19, color: kWhite),
                          ),
                          const SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (var artist in favoriteArtists) ...[
                                  Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                            artist['imageURL'] ?? ''),
                                        backgroundColor: Colors.grey,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        artist['name'] ?? '',
                                        textAlign: TextAlign.center,
                                        style: SenMedium.copyWith(
                                            fontSize: 16, color: kWhite),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                ],
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BotNavBar(
            currentIndex: navbarIndex,
            onTap: (index) {
              ref.read(navbarIndexProvider.notifier).state = index;
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/homepage');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/search');
                  break;
                case 2:
                  Navigator.pushNamed(context, '/playingqueue');
                  break;
              }
            },
          ),
        );
      },
    );
  }
}

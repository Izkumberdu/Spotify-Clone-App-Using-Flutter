import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            body: Center(child: Text('No recently played items found')),
          );
        }

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
                  SizedBox(height: 12),
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0; i < snapshot.data!.length; i++) ...[
                          RecentlyPlayedItem(
                            height: 106,
                            width: 106,
                            imageUrl: snapshot.data![i]['imageUrl'] ?? '',
                            isArtist: snapshot.data![i]['artist'] ?? false,
                            name: snapshot.data![i]['name'] ?? '',
                          ),
                          if (i < snapshot.data!.length - 1)
                            const SizedBox(width: 20),
                        ],
                      ],
                    ),
                  ),
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
                  Navigator.pushNamed(context, '/searchMenu');
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lettersquared/components/bottomNavbar.dart';
import 'package:lettersquared/provider/providers.dart';
import 'package:lettersquared/styles/app_styles.dart';

class PlaylistViewPage extends ConsumerWidget {
  const PlaylistViewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarIndex = ref.watch(navbarIndexProvider);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBlack,
      body: Stack(
        children: [
          Container(
            width: screenSize.width,
            height: screenSize.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF78644C),
                  const Color(0xFF78644C),
                  kBlack.withOpacity(0.7),
                  const Color(0xFF121212),
                ],
                stops: const [0.0, 0.4, 0.65, 0.8],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: Column(
                children: [
                  backChevron(),
                  const SizedBox(height: 30),
                  searchBar(),
                  const SizedBox(height: 40),
                  bigPicture(),
                  const SizedBox(height: 30),
                  Text(
                    'data'
                    ),
                  const SizedBox(height: 10),
                  Row(),
                  const SizedBox(height: 10),
                  Text('data')
                ],
              ),
            ),
          )
 
        ],
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
  }

  Container bigPicture() {
    return Container(
                  width: 250,
                  height: 250,
                  color: Colors.amber,
                );
  }

  Row searchBar() {
    return Row(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Find in playlist',
                          hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
                          prefixIcon: const Icon(Icons.search, color: Colors.white, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF7E6E5B),
                          contentPadding: const EdgeInsets.symmetric(vertical: 5)
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 60,
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Sort',
                          hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF7E6E5B),
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15)
                        ),
                      ),
                    ),

                  ],
                );
  }

  Align backChevron() {
    return const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20.0,
                    color: Colors.white,
                  ),
                );
  }
}
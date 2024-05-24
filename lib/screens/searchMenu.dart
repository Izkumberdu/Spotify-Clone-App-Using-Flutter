import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lettersquared/components/bottomNavbar.dart';
import 'package:lettersquared/components/musicTracker.dart';
import 'package:lettersquared/firebase/getSongs.dart';
import 'package:lettersquared/models/genre.dart';
import 'package:lettersquared/provider/providers.dart';
import 'package:lettersquared/styles/app_styles.dart';
import 'package:lettersquared/screens/trackview.dart';

class SearchMenu extends ConsumerWidget {
  const SearchMenu({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navbarIndex = ref.watch(navbarIndexProvider);
    final songsAsyncValue = ref.watch(getSongsProvider);

    return Scaffold(
      backgroundColor: kBlack,
      body: Stack(
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
                      style: SenBold.copyWith(fontSize: 25, color: kWhite),
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
                      ref.watch(storedLastPositionProvider).toString(),
                      textAlign: TextAlign.left,
                      style: SenSemiBold.copyWith(
                        fontSize: 18,
                        color: kWhite,
                      ),
                    ),
                    Image.asset('assets/images/icons/Shuffle.png'),
                  ],
                ),
                const SizedBox(height: 15),
                songsAsyncValue.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stackTrace) => Text('Error: $error'),
                  data: (songs) => Expanded(
                    child: ListView.builder(
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return songContainer(context, song, index, songs);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MusicTracker(),
          ),
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

  Widget songContainer(
      BuildContext context, Song song, int index, List<Song> songs) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Trackview(
              song: song,
              songs: songs,
              index: index,
              duration: Duration.zero,
              position: Duration.zero,
            ),
          ),
        );
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
            Image.asset('assets/images/icons/Play.png'),
            const SizedBox(width: 15),
            Image.asset('assets/images/icons/Heart_Solid.png'),
            const SizedBox(width: 10),
            Image.asset('assets/images/icons/more.png'),
          ],
        ),
      ),
    );
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
}

import 'package:flutter/material.dart';
import 'package:lettersquared/firebase/getSongs.dart';
import 'package:lettersquared/styles/app_styles.dart';

class SongContainer extends StatelessWidget {
  final Song song;
  final int index;
  final List<Song> songs;

  SongContainer({
    required this.song,
    required this.index,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
}

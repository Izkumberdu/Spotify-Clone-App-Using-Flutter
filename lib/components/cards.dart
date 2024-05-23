import 'package:flutter/material.dart';
import 'package:lettersquared/styles/app_styles.dart';

class CustomContainer extends StatelessWidget {
  final String imagePath;
  final String text;
  final bool isLikedSongs;

  const CustomContainer({
    super.key,
    required this.imagePath,
    required this.text,
    required this.isLikedSongs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 60,
      decoration: BoxDecoration(
        color: kDarkGrey,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(3),
              bottomLeft: Radius.circular(3),
            ),
            child: SizedBox(
              height: 60,
              width: 60,
              child: Image.asset(imagePath),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            isLikedSongs ? "Liked Songs" : text,
            style: SenBold.copyWith(fontSize: 12, color: kWhite),
          ),
        ],
      ),
    );
  }
}

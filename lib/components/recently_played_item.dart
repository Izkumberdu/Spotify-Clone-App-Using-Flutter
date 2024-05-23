import 'package:flutter/material.dart';
import 'package:lettersquared/styles/app_styles.dart';

class RecentlyPlayedItem extends StatelessWidget {
  final double width;
  final double height;
  final String imageUrl;
  final bool isArtist;
  final String name;

  const RecentlyPlayedItem({
    super.key,
    required this.width,
    required this.height,
    required this.imageUrl,
    required this.isArtist,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          height: height,
          child: isArtist
              ? ClipOval(
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                )
              : Image.network(imageUrl, fit: BoxFit.cover),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          name,
          style: SenMedium.copyWith(fontSize: 14, color: kWhite),
        )
      ],
    );
  }
}

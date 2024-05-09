import 'package:flutter/material.dart';
import 'package:lettersquared/styles/app_styles.dart';

class Trackview extends StatefulWidget {
  const Trackview({super.key});

  @override
  State<Trackview> createState() => _TrackviewState();
}

class _TrackviewState extends State<Trackview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/icons/arrow-down.png'),
                Text(
                  'Album Title',
                  style: SenSemiBold.copyWith(
                    fontSize: 14,
                    color: kWhite,
                  ),
                ),
                Image.asset('assets/images/icons/more-horizontal.png')
              ],
            )
          ],
        ),
      ),
    );
  }
}

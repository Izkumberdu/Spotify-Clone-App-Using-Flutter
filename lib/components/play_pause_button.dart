import 'package:flutter/material.dart';
import 'package:lettersquared/audio/song_handler.dart';
import 'package:lettersquared/styles/app_styles.dart';

class PlayPauseButton extends StatelessWidget {
  final SongHandler songHandler;
  final double size;

  const PlayPauseButton(
      {super.key, required this.songHandler, required this.size});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: songHandler.playbackState.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool playing = snapshot.data!.playing;
            return IconButton(
                onPressed: () {
                  if (playing) {
                    songHandler.pause();
                  } else {
                    songHandler.play();
                  }
                },
                icon: playing
                    ? Icon(
                        Icons.pause_rounded,
                        size: size,
                        color: kWhite,
                      )
                    : Icon(
                        Icons.play_arrow_rounded,
                        size: size,
                        color: kWhite,
                      ));
          } else {
            return SizedBox.shrink();
          }
        });
  }
}

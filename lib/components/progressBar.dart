import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:lettersquared/audio/song_handler.dart';
import 'package:lettersquared/styles/app_styles.dart';

class SongProgress extends StatelessWidget {
  final Duration totalDuration;
  final SongHandler songHandler;
  final TimeLabelLocation timeLabelLocation;
  const SongProgress(
      {super.key,
      required this.totalDuration,
      required this.songHandler,
      required this.timeLabelLocation});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: AudioService.position,
      builder: (context, snapshot) {
        Duration? postion = snapshot.data;
        return ProgressBar(
          progress: postion ?? Duration.zero,
          total: totalDuration,
          onSeek: (value) {
            songHandler.seek(value);
          },
          barHeight: 5,
          progressBarColor: kWhite,
          baseBarColor: kGrey,
          thumbColor: kGrey,
          timeLabelLocation: timeLabelLocation,
          thumbGlowRadius: 5,
          timeLabelTextStyle: SenSemiBold.copyWith(fontSize: 14),
        );
      },
    );
  }
}

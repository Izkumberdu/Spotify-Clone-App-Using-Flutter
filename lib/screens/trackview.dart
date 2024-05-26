import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:lettersquared/audio/song_handler.dart';
import 'package:lettersquared/components/play_pause_button.dart';
import 'package:lettersquared/components/progressBar.dart';
import 'package:lettersquared/constants/size_config.dart';
import 'package:lettersquared/styles/app_styles.dart';

class TrackView extends StatelessWidget {
  final SongHandler songHandler;

  const TrackView({super.key, required this.songHandler});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: songHandler.mediaItem.stream,
      builder: (context, snapshot) {
        MediaItem? playingSong = snapshot.data;
        return playingSong == null
            ? const SizedBox.shrink()
            : _buildTrackView(context, playingSong);
      },
    );
  }

  Scaffold _buildTrackView(BuildContext context, MediaItem playingSong) {
    SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);
    String color = playingSong.extras?['color'];
    final int colorValue = int.parse('0xff$color');
    return Scaffold(
      backgroundColor: kBlack,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: SizeConfig.blockSizeVertical! * 70,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(colorValue).withOpacity(0.2),
                    kBlack,
                  ],
                  stops: [0.4, 1],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset('assets/images/icons/arrow-down.png'),
                    ),
                    Text(
                      'Album Title',
                      style: SenSemiBold.copyWith(fontSize: 14, color: kWhite),
                    ),
                    Image.asset('assets/images/icons/more-horizontal.png')
                  ],
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red,
                  ),
                  height: SizeConfig.blockSizeVertical! * 40,
                  width: SizeConfig.blockSizeHorizontal! * 90,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      playingSong.artUri.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 10),
                songInformation(playingSong),
                SizedBox(height: SizeConfig.blockSizeVertical! * 0.5),
                SongProgress(
                  totalDuration: playingSong.duration!,
                  songHandler: songHandler,
                  timeLabelLocation: TimeLabelLocation.below,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 0.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // songHandler.shuffleList();
                      },
                      child: Image.asset('assets/images/icons/Shuffle.png',
                          height: 22, width: 22),
                    ),
                    GestureDetector(
                      onTap: () {
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: IconButton(
                            icon: Icon(Icons.skip_previous, color: kWhite),
                            onPressed: () {
                              songHandler.skipToPrevious();
                              songHandler.play();
                            },
                          ),
                        );
                      },
                      child: Image.asset('assets/images/icons/Back.png',
                          height: 36, width: 36),
                    ),
                    PlayPauseButton(songHandler: songHandler, size: 50),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
                        icon: Icon(Icons.skip_next, color: kWhite),
                        onPressed: () {
                          songHandler.skipToNext();
                          songHandler.play();
                        },
                      ),
                    ),
                    Image.asset('assets/images/icons/Repeat-Inactive.png',
                        height: 22, width: 22),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget songInformation(MediaItem playingSong) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          playingSong.title,
          textAlign: TextAlign.left,
          style: SenSemiBold.copyWith(fontSize: 22, color: kWhite),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical! * 0.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              playingSong.artist ?? 'Unknown Artist',
              style: SenMedium.copyWith(color: kLightGrey, fontSize: 16),
            ),
            Image.asset('assets/images/icons/heart-outline.png'),
          ],
        ),
      ],
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
}

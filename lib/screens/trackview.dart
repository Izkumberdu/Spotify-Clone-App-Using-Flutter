import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
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
    String color = playingSong.extras?['color'] ?? '';
    final int colorValue = int.tryParse('0xff$color') ?? 0x000000;
    return Scaffold(
      backgroundColor: Colors.black,
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
                    Colors.black,
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
                      style: SenSemiBold.copyWith(
                          fontSize: 14, color: Colors.white),
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
                StreamBuilder<bool>(
                  stream: songHandler.shuffleModeStream,
                  builder: (context, shuffleSnapshot) {
                    final isShuffling = shuffleSnapshot.data ?? false;
                    return StreamBuilder<bool>(
                      stream: songHandler.loopModeStream,
                      builder: (context, loopSnapshot) {
                        final isLooping = loopSnapshot.data ?? false;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                songHandler.toggleShuffle();
                              },
                              child: Icon(
                                CupertinoIcons.shuffle,
                                size: 22,
                                color:
                                    isShuffling ? Colors.green : Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                songHandler.skipToPrevious();
                                songHandler.play();
                              },
                              child: Image.asset(
                                'assets/images/icons/Back.png',
                                height: 36,
                                width: 36,
                              ),
                            ),
                            PlayPauseButton(songHandler: songHandler, size: 50),
                            GestureDetector(
                              onTap: () {
                                songHandler.skipToNext();
                                songHandler.play();
                              },
                              child: Image.asset(
                                'assets/images/icons/Forward.png',
                                height: 36,
                                width: 36,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                songHandler.toggleLoop();
                              },
                              child: Icon(
                                Icons.loop_sharp,
                                color: isLooping ? Colors.green : Colors.white,
                                size: 22,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column songInformation(MediaItem playingSong) {
    return Column(
      children: [
        Text(
          playingSong.title,
          style: SenBold.copyWith(fontSize: 24, color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        Text(
          playingSong.artist ?? '',
          style: SenMedium.copyWith(fontSize: 14, color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

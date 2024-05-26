import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:lettersquared/audio/song_handler.dart';
import 'package:lettersquared/components/play_pause_button.dart';
import 'package:lettersquared/components/progressBar.dart';
import 'package:lettersquared/screens/trackview.dart';
import 'package:lettersquared/styles/app_styles.dart';

class PlayerDeck extends StatefulWidget {
  final SongHandler songHandler;

  const PlayerDeck({super.key, required this.songHandler});

  @override
  _PlayerDeckState createState() => _PlayerDeckState();
}

class _PlayerDeckState extends State<PlayerDeck> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: widget.songHandler.mediaItem.stream,
      builder: (context, snapshot) {
        MediaItem? playingSong = snapshot.data;
        return playingSong == null
            ? const SizedBox.shrink()
            : buildCard(context, playingSong);
      },
    );
  }

  Dismissible buildCard(BuildContext context, MediaItem playingSong) {
    String color = playingSong.extras?['color'];
    final int colorValue = int.parse('0xff$color');
    return Dismissible(
      key: Key(playingSong.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        widget.songHandler.pause();
        widget.songHandler.stop();
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackView(songHandler: widget.songHandler),
            ),
          );
        },
        child: Card(
          margin: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Color(colorValue).withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ProgressSlider(playingSong.duration!),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          playingSong.artUri.toString(),
                          height: 50,
                          width: 50,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              playingSong.title,
                              style: SenSemiBold.copyWith(
                                  fontSize: 14, color: kWhite),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              playingSong.artist ?? '',
                              style: SenSemiBold.copyWith(
                                  fontSize: 12, color: kGrey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: IconButton(
                            icon:
                                const Icon(Icons.skip_previous, color: kWhite),
                            onPressed: () {
                              widget.songHandler.play();
                              widget.songHandler.skipToPrevious();
                            },
                          ),
                        ),
                        PlayPauseButton(
                            songHandler: widget.songHandler, size: 30),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: IconButton(
                            icon: const Icon(Icons.skip_next, color: kWhite),
                            onPressed: () {
                              widget.songHandler.skipToNext();
                              widget.songHandler.play();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ProgressSlider(Duration totalDuration) {
    return SongProgress(
      totalDuration: totalDuration,
      songHandler: widget.songHandler,
      timeLabelLocation: TimeLabelLocation.none,
    );
  }
}

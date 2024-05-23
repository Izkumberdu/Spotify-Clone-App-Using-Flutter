import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lettersquared/constants/size_config.dart';
import 'package:lettersquared/firebase/getSongs.dart';
import 'package:lettersquared/provider/audioplayer.dart';
import 'package:lettersquared/provider/providers.dart';
import 'package:lettersquared/screens/trackview.dart';
import 'package:lettersquared/styles/app_styles.dart';

class MusicTracker extends ConsumerStatefulWidget {
  const MusicTracker({Key? key}) : super(key: key);

  @override
  _MusicTrackerState createState() => _MusicTrackerState();
}

class _MusicTrackerState extends ConsumerState<MusicTracker> {
  void _subscribeToPositionChanges(WidgetRef ref, AudioHandler audioHandler) {
    audioHandler.audioPlayer.positionStream.listen((newPosition) {
      ref.read(lastPositionProvider.notifier).state = newPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);
    final currentSong = ref.watch(currentSongProvider);
    final musicTrackIsPlaying = ref.watch(musicTrackerIsPlaying);
    final currentIndex = ref.watch(currentSongIndexProvider);
    final duration = ref.watch(lastDurationProvider);
    final position = ref.watch(lastPositionProvider);
    final audioHandler = AudioHandler(ref);

    if (currentSong == null) {
      return SizedBox.shrink();
    }
    if (trackViewIsPlaying == true) {
      audioHandler.dispose();
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (musicTrackIsPlaying) {
        await audioHandler.setAudioSource(currentSong.url, ref);
        await audioHandler.audioPlayer.seek(position);
        await audioHandler.play(ref);
      } else {
        audioHandler.dispose();
      }
    });

    return GestureDetector(
      onTap: () {
        ref.read(lastDurationProvider.notifier).state = duration;
        ref.read(lastPositionProvider.notifier).state = position;
        final currentIndex = ref.read(currentSongIndexProvider);
        final songs = ref.watch(songListProvider);
        audioHandler.dispose();
        ref.read(musicTrackerIsPlaying.notifier).state = false;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Trackview(
            song: currentSong,
            index: currentIndex,
            songs: songs,
          ),
        ));
      },
      child: Container(
        height: SizeConfig.blockSizeVertical! * 10,
        width: SizeConfig.blockSizeHorizontal! * 100,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(0.4),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: SliderComponentShape.noThumb,
                activeTrackColor: Colors.grey,
                inactiveTrackColor: Colors.grey.withOpacity(0.3),
                trackHeight: 4.0,
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) {
                  final newPosition = Duration(seconds: value.toInt());
                  audioHandler.audioPlayer.seek(newPosition);
                },
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(
                  currentSong.imageSource,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentSong.name,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        currentSong.artist,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.skip_previous, color: Colors.white),
                  onPressed: () async {
                    await audioHandler.audioPlayer.stop();
                    int newIndex = currentIndex - 1;
                    if (newIndex < 0) {
                      newIndex = ref.read(songListProvider).length - 1;
                    }
                    ref.read(currentSongIndexProvider.notifier).state =
                        newIndex;
                    audioHandler.resetTime(ref);
                  },
                ),
                IconButton(
                  icon: Icon(
                      musicTrackIsPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white),
                  onPressed: () async {
                    if (musicTrackIsPlaying) {
                      await audioHandler.pause(ref);
                      ref.read(musicTrackerIsPlaying.notifier).state = false;
                    } else {
                      await audioHandler.play(ref);
                      ref.read(musicTrackerIsPlaying.notifier).state = true;
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.skip_next, color: Colors.white),
                  onPressed: () async {
                    await audioHandler.audioPlayer.stop();
                    int newIndex = currentIndex + 1;
                    if (newIndex >= ref.read(songListProvider).length) {
                      newIndex = 0;
                    }
                    ref.read(currentSongIndexProvider.notifier).state =
                        newIndex;
                    audioHandler.resetTime(ref);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

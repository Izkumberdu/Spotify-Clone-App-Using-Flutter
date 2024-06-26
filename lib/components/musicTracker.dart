import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lettersquared/constants/size_config.dart';
import 'package:lettersquared/provider/audioplayer.dart'; // Import the AudioHandler class
import 'package:lettersquared/provider/providers.dart';

class MusicTracker extends ConsumerWidget {
  const MusicTracker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);
    final currentSong = ref.watch(currentSongProvider);
    final musicTrackIsPlaying = ref.watch(musicTrackerIsPlaying);
    final currentIndex = ref.watch(currentSongIndexProvider);
    final duration = ref.watch(lastDurationProvider);
    final position = ref.watch(lastPositionProvider);
    bool isPlaying = musicTrackIsPlaying;

    final audioHandler = AudioHandler(ref);

    if (currentSong == null) {
      return const SizedBox.shrink();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (musicTrackIsPlaying) {
        await audioHandler.setAudioSource(currentSong.url);
        await audioHandler.play(ref);
      } else {
        audioHandler.dispose();
      }
    });

    return Container(
      height: SizeConfig.blockSizeVertical! * 10,
      width: SizeConfig.blockSizeHorizontal! * 100,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.4),
        borderRadius: const BorderRadius.only(
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
              onChanged: (value) async {
                final newPosition = Duration(seconds: value.toInt());
                await audioHandler.seek(ref, newPosition);
                if (!isPlaying) {
                  await audioHandler.play(ref);
                  isPlaying = true;
                }
              },
            ),
          ),
          const SizedBox(
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
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentSong.name,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      currentSong.artist,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: () {
                  audioHandler.audioPlayer.stop();
                  int newIndex = currentIndex - 1;
                  if (newIndex < 0) {
                    newIndex = ref.read(songListProvider).length - 1;
                  }
                  ref.read(currentSongIndexProvider.notifier).state = newIndex;
                },
              ),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white),
                onPressed: () async {
                  if (isPlaying) {
                    isPlaying = false;
                    await audioHandler.pause(ref);
                  } else {
                    isPlaying = true;
                    await audioHandler.play(ref);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: () {
                  audioHandler.audioPlayer.stop();
                  int newIndex = currentIndex + 1;
                  if (newIndex >= ref.read(songListProvider).length) {
                    newIndex = 0;
                  }
                  ref.read(currentSongIndexProvider.notifier).state = newIndex;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

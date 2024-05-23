import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lettersquared/constants/size_config.dart';
import 'package:lettersquared/firebase/getSongs.dart';
import 'package:lettersquared/styles/app_styles.dart';
import 'package:lettersquared/provider/providers.dart';
import 'package:lettersquared/provider/audioplayer.dart';

class Trackview extends ConsumerStatefulWidget {
  const Trackview({
    Key? key,
    required this.song,
    required this.index,
    required this.songs,
  }) : super(key: key);

  final Song song;
  final int index;
  final List<Song> songs;

  @override
  ConsumerState<Trackview> createState() => _TrackviewState();
}

class _TrackviewState extends ConsumerState<Trackview> {
  late AudioHandler audioHandler;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    audioHandler = AudioHandler(ref);
    currentIndex = widget.index;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      duration = ref.watch(lastDurationProvider);
      ref.read(songListProvider.notifier).state = widget.songs;
      ref.read(currentSongIndexProvider.notifier).state = widget.index;
      ref.watch(musicTrackerIsPlaying.notifier).state = false;

      if (ref.watch(musicTrackerIsPlaying) == false) {
        ref.read(trackViewIsPlaying.notifier).state = true;
        await setAudio();
      } else {
        await audioHandler.pause(ref);
      }
    });

    audioHandler.audioPlayer.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
    });

    audioHandler.audioPlayer.durationStream.listen((newDuration) {
      setState(() {
        duration = newDuration ?? Duration.zero;
      });
    });

    audioHandler.audioPlayer.positionStream.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  Future<void> setAudio() async {
    final lastPosition = ref.read(lastPositionProvider);
    await audioHandler.setAudioSource(
      widget.songs[currentIndex].url,
      ref,
    );
    if (lastPosition != Duration.zero) {
      await audioHandler.seek(ref, lastPosition);
      await audioHandler.play(ref);
    }
  }

  void updateSong(int newIndex) {
    setState(() {
      currentIndex = newIndex;
      if (currentIndex < 0) {
        currentIndex = widget.songs.length - 1;
      } else if (currentIndex >= widget.songs.length) {
        currentIndex = 0;
      }
      setAudio();
    });
  }

  @override
  void dispose() {
    audioHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);
    String color = widget.songs[currentIndex].color;
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
                        ref.read(trackViewIsPlaying.notifier).state = false;
                        ref.read(musicTrackerIsPlaying.notifier).state = true;
                        ref.read(lastDurationProvider.notifier).state =
                            duration;
                        ref.read(currentSongIndexProvider.notifier).state =
                            currentIndex;
                        ref.read(lastPositionProvider.notifier).state =
                            position;
                        audioHandler.dispose();
                        Navigator.pop(context);
                      },
                      child: Image.asset('assets/images/icons/arrow-down.png'),
                    ),
                    Text(
                      '$currentIndex',
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
                      widget.songs[currentIndex].imageSource,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 10),
                songInformation(),
                SizedBox(height: SizeConfig.blockSizeVertical! * 0.5),
                Slider(
                  min: 0,
                  max: duration > Duration.zero
                      ? duration.inSeconds.toDouble()
                      : 0.0,
                  value: position.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final newPosition = Duration(seconds: value.toInt());
                    await audioHandler.seek(ref, newPosition);
                    if (!isPlaying) {
                      await audioHandler.play(ref);
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatTime(position),
                      style:
                          SenMedium.copyWith(fontSize: 10, color: kLightGrey),
                    ),
                    Text(
                      formatTime(duration - position),
                      style:
                          SenMedium.copyWith(fontSize: 10, color: kLightGrey),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 0.5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/images/icons/Shuffle.png',
                        height: 22, width: 22),
                    GestureDetector(
                      onTap: () {
                        updateSong(currentIndex - 1);
                        audioHandler.resetTime(ref);
                      },
                      child: Image.asset('assets/images/icons/Back.png',
                          height: 36, width: 36),
                    ),
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: kWhite,
                      child: IconButton(
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        iconSize: 50,
                        color: kBlack,
                        onPressed: () async {
                          if (isPlaying) {
                            await audioHandler.pause(ref);
                          } else {
                            await audioHandler.play(ref);
                          }
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        updateSong(currentIndex + 1);
                        audioHandler.resetTime(ref);
                      },
                      child: Image.asset('assets/images/icons/Forward.png',
                          height: 36, width: 36),
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

  Widget songInformation() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.songs[currentIndex].name,
            textAlign: TextAlign.left,
            style: SenSemiBold.copyWith(fontSize: 22, color: kWhite),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical! * 0.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.songs[currentIndex].artist,
                style: SenMedium.copyWith(color: kLightGrey, fontSize: 16),
              ),
              Image.asset('assets/images/icons/heart-outline.png'),
            ],
          ),
        ],
      ),
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

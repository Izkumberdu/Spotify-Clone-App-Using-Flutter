import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lettersquared/constants/size_config.dart';
import 'package:lettersquared/firebase/getSongs.dart';
import 'package:lettersquared/styles/app_styles.dart';

class Trackview extends StatefulWidget {
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
  State<Trackview> createState() => _TrackviewState();
}

class _TrackviewState extends State<Trackview> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    setAudio();
    audioPlayer.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
    });
    audioPlayer.durationStream.listen((newDuration) {
      setState(() {
        duration = newDuration ?? Duration.zero;
      });
    });
    audioPlayer.positionStream.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  Future<void> setAudio() async {
    await audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(widget.songs[currentIndex].url)));
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
    audioPlayer.dispose();
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
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        audioPlayer.dispose();
                        Navigator.pop(context);
                      },
                      child: Image.asset('assets/images/icons/arrow-down.png'),
                    ),
                    Text(
                      '${currentIndex}',
                      style: SenSemiBold.copyWith(
                        fontSize: 14,
                        color: kWhite,
                      ),
                    ),
                    Image.asset('assets/images/icons/more-horizontal.png')
                  ],
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical! * 10,
                ),
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
                SizedBox(
                  height: SizeConfig.blockSizeVertical! * 10,
                ),
                songInformation(),
                SizedBox(
                  height: SizeConfig.blockSizeVertical! * 0.5,
                ),
                Slider(
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final newPosition = Duration(seconds: value.toInt());
                    await audioPlayer.seek(newPosition);
                    if (!isPlaying) {
                      await audioPlayer.play();
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatTime(position),
                      style: SenMedium.copyWith(
                        fontSize: 10,
                        color: kLightGrey,
                      ),
                    ),
                    Text(
                      formatTime(duration - position),
                      style: SenMedium.copyWith(
                        fontSize: 10,
                        color: kLightGrey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical! * 0.5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/icons/Shuffle.png',
                      height: 22,
                      width: 22,
                    ),
                    GestureDetector(
                      onTap: () {
                        updateSong(currentIndex - 1);
                      },
                      child: Image.asset(
                        'assets/images/icons/Back.png',
                        height: 36,
                        width: 36,
                      ),
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
                            await audioPlayer.pause();
                          } else {
                            await audioPlayer.play();
                          }
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        updateSong(currentIndex + 1);
                      },
                      child: Image.asset(
                        'assets/images/icons/Forward.png',
                        height: 36,
                        width: 36,
                      ),
                    ),
                    Image.asset(
                      'assets/images/icons/Repeat-Inactive.png',
                      height: 22,
                      width: 22,
                    ),
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
          SizedBox(
            height: SizeConfig.blockSizeVertical! * 0.5,
          ),
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

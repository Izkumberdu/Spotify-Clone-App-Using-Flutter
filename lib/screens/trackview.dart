import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lettersquared/constants/size_config.dart';
import 'package:lettersquared/firebase/getSongs.dart';
import 'package:lettersquared/styles/app_styles.dart';

class Trackview extends StatefulWidget {
  const Trackview({
    Key? key,
    required this.song,
    required this.songs,
    required this.index,
  }) : super(key: key);

  final Song song;
  final List<Song> songs;
  final int index;

  @override
  State<Trackview> createState() => _TrackviewState();
}

class _TrackviewState extends State<Trackview> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  late int currentIndex;
  late Song currentSong;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    currentSong = widget.song;
    setAudio(currentSong.url);
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

  Future<void> setAudio(String url) async {
    await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));
  }

  void updateSong(int newIndex) {
    if (newIndex >= 0 && newIndex < widget.songs.length) {
      setState(() {
        currentIndex = newIndex;
        currentSong = widget.songs[newIndex];
        setAudio(currentSong.url);
      });
    }
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
    String color = currentSong.color;
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
                SizedBox(
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
                      '${currentIndex + 1}/${widget.songs.length}', // Displaying index here
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
                      currentSong.imageSource,
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
            currentSong.name,
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
                currentSong.artist,
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

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lettersquared/constants/size_config.dart';
import 'package:lettersquared/styles/app_styles.dart';

class Trackview extends StatefulWidget {
  const Trackview({
    super.key,
  });

  @override
  State<Trackview> createState() => _TrackviewState();
}

class _TrackviewState extends State<Trackview> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
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
    var url =
        "https://ieczccbopoftaobhqmwz.supabase.co/storage/v1/object/public/Songs/Laufey%20-%20Fragile%20(Official%20Audio).mp3";
    await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));
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
                    const Color(0xFF505424).withOpacity(0.2),
                    kBlack,
                  ],
                  stops: const [0.4, 1],
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
                        Navigator.pop(context);
                      },
                      child: Image.asset('assets/images/icons/arrow-down.png'),
                    ),
                    Text(
                      'Album Title',
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
                    child: Image.asset(
                      'assets/images/songs/fragile.jpg',
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
                    Image.asset(
                      'assets/images/icons/Back.png',
                      height: 36,
                      width: 36,
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
                    Image.asset(
                      'assets/images/icons/Forward.png',
                      height: 36,
                      width: 36,
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
}

Widget songInformation() {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fragile',
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
              'Laufey',
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

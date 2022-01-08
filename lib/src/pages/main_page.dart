import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app_ui/src/helpers/helpers.dart';
import 'package:music_app_ui/src/providers/player_provider.dart';
import 'package:music_app_ui/src/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          SafeArea(
            child: Column(
              children: [
                CustomAppbar(),
                CoverArt(),
                Info(),
                SizedBox(height: 10),
                Expanded(child: Lyrics())
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.center,
          colors: [
            Color(0xff333333e),
            Color(0xff201e28),
          ],
        ),
      ),
    );
  }
}

class Lyrics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lyrics = getLyrics();
    return Container(
      child: ListWheelScrollView(
        physics: BouncingScrollPhysics(),
        diameterRatio: 1.5,
        itemExtent: 42,
        children: lyrics
            .map(
              (line) => Text(line,
                  style: TextStyle(color: Colors.white.withOpacity(0.3))),
            )
            .toList(),
      ),
    );
  }
}

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool firsTime = true;
  late AnimationController controller;

  final assetAudioPlayer = new AssetsAudioPlayer();

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  void open() {
    final audioPlayerProvider =
        Provider.of<AudioPlayerProvider>(context, listen: false);

    assetAudioPlayer.open(Audio("assets/Breaking-Benjamin-Far-Away.mp3"),
        autoStart: true);

    assetAudioPlayer.currentPosition.listen((duration) {
      audioPlayerProvider.current = duration;
    });

    assetAudioPlayer.current.listen((playingAudio) {
      audioPlayerProvider.songDuration =
          playingAudio?.audio.duration ?? const Duration(seconds: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Text(
              "Far Away",
              style:
                  TextStyle(fontSize: 30, color: Colors.white.withOpacity(0.8)),
            ),
            Text("-Breaking Benjamin-",
                style: TextStyle(color: Colors.white.withOpacity(0.3))),
          ]),
          FloatingActionButton(
            elevation: 0,
            onPressed: () async {
              final audioPlayerProvider =
                  Provider.of<AudioPlayerProvider>(context, listen: false);
              if (isPlaying) {
                controller.reverse();
                audioPlayerProvider.controller.stop();
              } else {
                controller.forward();
                audioPlayerProvider.controller.repeat();
              }

              if (firsTime) {
                open();
                firsTime = false;
              } else {
                await assetAudioPlayer.playOrPause();
              }

              isPlaying = !isPlaying;
            },
            backgroundColor: Colors.yellow.shade700,
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: controller,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          )
        ],
      ),
    );
  }
}

class CoverArt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 100),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Cover(),
          ProgressBar(),
        ],
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final textStyle = TextStyle(color: Colors.white.withOpacity(0.3));
  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    final percent = audioPlayerProvider.percent;

    const height = 220.0;
    return Column(
      children: [
        Text('${audioPlayerProvider.songTotalDuration}', style: textStyle),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: height,
              width: 3,
              color: Colors.white.withOpacity(0.1),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: height * percent,
              width: 3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
        Text('${audioPlayerProvider.currentSecond}', style: textStyle),
      ],
    );
  }
}

class Cover extends StatelessWidget {
  final decoration = BoxDecoration(
    color: Colors.white.withOpacity(0.1),
    shape: BoxShape.circle,
  );

  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);

    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xff484750),
            Color(0xff1e1c24),
          ],
        ),
        // color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      width: 250,
      height: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SpinPerfect(
              duration: const Duration(seconds: 10),
              infinite: true,
              animate: false,
              manualTrigger: true,
              controller: audioPlayerProvider.setController,
              child: Image(
                  fit: BoxFit.cover, image: AssetImage("assets/aurora.jpg")),
            ),
            Container(
              width: 25,
              height: 25,
              padding: const EdgeInsets.all(4),
              decoration:
                  BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

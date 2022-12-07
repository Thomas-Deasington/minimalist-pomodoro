import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Duration workDuration = const Duration(minutes: 25);
  Duration restDuration = const Duration(minutes: 5);
  String state = 'work';
  String playPause = 'play';

  Timer? countdownTimer;
  Duration timer = const Duration(minutes: 25);

  void setTimer() {
    if (state == 'work') {
      timer = workDuration;
    } else {
      timer = restDuration;
    }
  }

  void startTimer() {
    setState(() {
      playPause = 'pause';
    });
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    playPause = 'play';
    setState(() => countdownTimer!.cancel());
  }

  void resetTimer() {
    if (countdownTimer != null) {
      stopTimer();
    }
    setState(() => setTimer());
  }

  void setCountDown () {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = timer.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
        HapticFeedback.mediumImpact();
        setNextStage();
      } else {
        timer = Duration(seconds: seconds);
      }
    });
  }

  void setNextStage() {
    setState(() {
      if (state == 'work') {
        state = 'rest';
      } else {
        state = 'work';
      }
      resetTimer();
    });
  }

  Widget playPauseButton() {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (playPause == 'play') {
          startTimer();
        } else {
          stopTimer();
        }
      },
      icon: Icon(
        playPause == 'play' ? Icons.play_arrow : Icons.pause,
        size: 50,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(timer.inMinutes.remainder(60));
    final seconds = strDigits(timer.inSeconds.remainder(60));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state == 'work' ? 'Time to work 🧑‍💻' : 'Time to rest 😴',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$minutes:$seconds',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 100
                )
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  playPauseButton(),
                  const SizedBox(width: 20),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      resetTimer();
                    },
                    icon: const Icon(
                      Icons.refresh,
                      size: 50,
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setNextStage();
                    },
                    icon: const Icon(
                      Icons.skip_next,
                      size: 50
                    )
                  )
                ],
              )
            ]
          )
        )
      )
    );
  }
}

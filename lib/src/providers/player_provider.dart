import 'package:flutter/material.dart';

class AudioPlayerProvider with ChangeNotifier {
  bool _isPlaying = false;

  late Duration _songDuration = const Duration(seconds: 0);
  late Duration _current = const Duration(seconds: 0);

  late AnimationController controller;

  bool get isPlaying => _isPlaying;
  Duration get songDuration => _songDuration;
  Duration get current => _current;

  String get songTotalDuration => getDuration(songDuration);
  String get currentSecond => getDuration(current);

  double get percent => _songDuration.inSeconds > 0
      ? _current.inSeconds / _songDuration.inSeconds
      : 0;

  String getDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  set isPlaying(bool value) {
    _isPlaying = value;
    notifyListeners();
  }

  set songDuration(Duration value) {
    _songDuration = value;
    notifyListeners();
  }

  set current(Duration value) {
    _current = value;
    notifyListeners();
  }

  void setController(AnimationController animationController) {
    controller = animationController;
  }
}

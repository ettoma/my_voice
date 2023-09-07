import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';

class SoundPlayer {
  FlutterSoundPlayer? _audioPlayer;
  bool isPlaying = false;
  String fileBeingPlayed = '';

  Future init() async {
    _audioPlayer = FlutterSoundPlayer();
    await _audioPlayer!.openPlayer();
  }

  void dispose() {
    _audioPlayer!.closePlayer();
    _audioPlayer = null;
  }

  Future _play(VoidCallback whenFinished, String? fileName) async {
    await _audioPlayer!
        .startPlayer(fromURI: fileName, whenFinished: whenFinished);
  }

  Future _stop() async {
    await _audioPlayer!.stopPlayer();
    isPlaying = false;
  }

  Future togglePlaying(
      {required VoidCallback whenFinished, String? fileName}) async {
    if (_audioPlayer!.isStopped) {
      fileBeingPlayed = fileName!;
      await _play(whenFinished, fileName);
    } else {
      fileBeingPlayed = '';
      await _stop();
    }
  }
}

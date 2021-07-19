import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';

class SoundPlayer {
  FlutterSoundPlayer? _audioPlayer;

  Future init() async {
    _audioPlayer = FlutterSoundPlayer();
    await _audioPlayer!.openAudioSession();
  }

  void dispose() {
    _audioPlayer!.closeAudioSession();
    _audioPlayer = null;
  }

  Future _play(VoidCallback whenFinished, String? fileName) async {
    await _audioPlayer!
        .startPlayer(fromURI: fileName, whenFinished: whenFinished);
  }

  Future _stop() async {
    await _audioPlayer!.stopPlayer();
  }

  Future togglePlaying(
      {required VoidCallback whenFinished, String? fileName}) async {
    if (_audioPlayer!.isStopped) {
      await _play(whenFinished, fileName);
    } else {
      await _stop();
    }
  }
}

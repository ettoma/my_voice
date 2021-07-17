import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:path_provider/path_provider.dart';

class SoundPlayer {
  FlutterSoundPlayer? _audioPlayer;
  Directory? directory;
  String? file;

  Future init() async {
    getDirectory();
    _audioPlayer = FlutterSoundPlayer();
    await _audioPlayer!.openAudioSession();
  }

  void dispose() {
    _audioPlayer!.closeAudioSession();
    _audioPlayer = null;
  }

  void getDirectory() async {
    directory = await getApplicationDocumentsDirectory();
    file = directory!.uri.toFilePath(windows: false) + '177202114309.aac';
  }

  Future _play(VoidCallback whenFinished) async {
    await _audioPlayer!.startPlayer(fromURI: file, whenFinished: whenFinished);
  }

  Future _stop() async {
    await _audioPlayer!.stopPlayer();
  }

  Future togglePlaying({required VoidCallback whenFinished}) async {
    if (_audioPlayer!.isStopped) {
      await _play(whenFinished);
    } else {
      await _stop();
    }
  }
}

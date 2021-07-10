import 'dart:convert';

import 'package:audio_journal/models/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Recording extends StatefulWidget {
  const Recording({Key? key}) : super(key: key);

  @override
  State<Recording> createState() => _RecordingState();
}

class _RecordingState extends State<Recording> {
  FlutterSoundRecorder _myRecorder = FlutterSoundRecorder();
  bool _myRecorderIsInited = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _myRecorder.openAudioSession().then((value) {
      setState(() {
        _myRecorderIsInited = true;
      });
    });
  }

  @override
  void dispose() {
    _myRecorder.closeAudioSession();
    super.dispose();
  }

  Future<void> record() async {
    await _myRecorder.startRecorder(toFile: 'test_audio');
  }

// it doesn't work yet, need to check videos
  Future<void> stopRecorder() async {
    await _myRecorder.stopRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        body: Column(
          children: [
            IconButton(
                onPressed: () {
                  _isRecording == false ? record() : stopRecorder();
                },
                icon: FaIcon(FontAwesomeIcons.microphone)),
          ],
        ));
  }
}

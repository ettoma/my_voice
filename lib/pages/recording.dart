import 'dart:io';

import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/models/sound_recorder.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';

class Recording extends StatefulWidget {
  const Recording({Key? key}) : super(key: key);

  @override
  State<Recording> createState() => _RecordingState();
}

class _RecordingState extends State<Recording> {
  final recorder = SoundRecorder();
  final _controller = TextEditingController();
  Directory? _directory;
  Stream<FileSystemEntity>? _directoryFiles;
  // bool isRecording = recorder.isRecording;

  Future getDirectory() async {
    _directory = await getApplicationDocumentsDirectory();
    _directoryFiles = _directory!.list();
    return _directoryFiles;
  }

  @override
  void initState() {
    super.initState();
    recorder.init();
    getDirectory();
  }

  @override
  void dispose() {
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          IconButton(
            onPressed: () async {
              final isRecording = await recorder.toggleRecording();
              setState(() {});
              getDirectory();
            },
            icon: const FaIcon(FontAwesomeIcons.recordVinyl),
          ),
          TextField(
            controller: _controller,
            onChanged: (e) {},
          ),
          Column(
              children: _directoryFiles!.forEach((item) {
            Text(item.toString());
          })),
        ],
      ),
    );
  }
}

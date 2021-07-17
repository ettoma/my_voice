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
  List<FileSystemEntity>? file;
  List fileName = [];
  Directory? directory;
  // bool isRecording = recorder.isRecording;

  void getDirectory() async {
    directory = await getApplicationDocumentsDirectory();
    file = directory!.listSync();
    setState(
      () {
        for (var element in file!) {
          fileName.add(element.path.split('/').last);
        }
        getListFiles();
      },
    );
  }

  ListView getListFiles() {
    return ListView.builder(
      itemCount: fileName.length,
      itemBuilder: (BuildContext context, int index) {
        return Text(fileName[index]);
      },
    );
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
              setState(() {
                getDirectory();
              });
            },
            icon: const FaIcon(FontAwesomeIcons.recordVinyl),
          ),
          Expanded(child: getListFiles()),
        ],
      ),
    );
  }
}

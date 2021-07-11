import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/models/sound_recorder.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Recording extends StatefulWidget {
  const Recording({Key? key}) : super(key: key);

  @override
  State<Recording> createState() => _RecordingState();
}

class _RecordingState extends State<Recording> {
  final recorder = SoundRecorder();
  // bool isRecording = recorder.isRecording;

  @override
  void initState() {
    super.initState();
    recorder.init();
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
            },
            icon: const FaIcon(FontAwesomeIcons.recordVinyl),
          )
        ],
      ),
    );
  }
}

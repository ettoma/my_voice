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
    bool isFileRecorded = false;
    String? mood;
    String? tag;

    return Scaffold(
      appBar: appBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24.0, left: 8, right: 8),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Recorder'),
                IconButton(
                  onPressed: () async {
                    if (recorder.isRecording != false) {
                      await showDialog(
                        // barrierDismissible: false,
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Popup'),
                        ),
                      );
                      recorder.updateDB('mood', 'tag');
                    }
                    recorder.toggleRecording();
                    setState(() {});
                  },
                  icon: recorder.isRecording
                      ? const FaIcon(FontAwesomeIcons.stop)
                      : const FaIcon(FontAwesomeIcons.solidCircle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

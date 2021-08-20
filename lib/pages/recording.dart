import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/models/sound_recorder.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Recording extends StatefulWidget {
  const Recording({Key? key}) : super(key: key);

  @override
  State<Recording> createState() => _RecordingState();
}

class _RecordingState extends State<Recording> {
  final recorder = SoundRecorder();
  final CountDownController _timerController = CountDownController();

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
    bool isButtonRecording = false;
    String mood = '';
    String tag = '';
    TextEditingController _moodTextController = TextEditingController();
    TextEditingController _tagTextController = TextEditingController();

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
                CircularCountDownTimer(
                  controller: _timerController,
                  textFormat: 's',
                  autoStart: false,
                  width: 100,
                  height: 100,
                  duration: 5,
                  ringColor: Colors.blue,
                  fillColor: Colors.green,
                  onStart: () {
                    recorder.record();
                  },
                  onComplete: () async {
                    isButtonRecording = false;
                    recorder.stop();
                    if (recorder.isRecordingCompleted == true) {
                      await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => Dialog(
                          child: Container(
                            padding: EdgeInsets.all(12),
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Column(
                              children: [
                                TextField(
                                  controller: _moodTextController,
                                  onChanged: (e) =>
                                      mood = _moodTextController.text,
                                  decoration:
                                      InputDecoration(labelText: 'Mood'),
                                ),
                                TextField(
                                  controller: _tagTextController,
                                  onChanged: (e) =>
                                      tag = _tagTextController.text,
                                  decoration: InputDecoration(labelText: 'Tag'),
                                ),
                                IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: FaIcon(FontAwesomeIcons.check),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                      recorder.updateDB(mood.isNotEmpty ? mood : '',
                          tag.isNotEmpty ? tag : '');
                    }
                    setState(() {});
                  },
                ),
                IconButton(
                  onPressed: () {
                    _timerController.start();
                  },
                  icon: isButtonRecording == true
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

import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/models/sound_recorder.dart';
import 'package:audio_journal/utils/colours.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'audio_player.dart';

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
      appBar: appBar(context),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Text(
                'record',
                style: TextStyle(
                    color: AppColours().titleColour,
                    fontSize: AppColours().titleSize,
                    fontWeight: FontWeight.w500),
              ),
              Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.hardEdge,
                  children: [
                    new CircularCountDownTimer(
                      isTimerTextShown: false,
                      controller: _timerController,
                      autoStart: false,
                      width: 250,
                      height: 250,
                      strokeWidth: 40,
                      duration: 5,
                      ringColor: AppColours().ringColour,
                      fillColor: Colors.amber,
                      initialDuration: 0,
                      // ringGradient: AppColours().fillColour,
                      // fillGradient: AppColours().fillColour,
                      onStart: () {
                        recorder.record();
                      },
                      onComplete: () async {
                        isButtonRecording = false;
                        recorder.stop();
                        // _timerController.resetTimer();

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
                                    decoration:
                                        InputDecoration(labelText: 'Tag'),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    icon: FaIcon(FontAwesomeIcons.check),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                        recorder.updateDB(mood.isNotEmpty ? mood : '',
                            tag.isNotEmpty ? tag : '');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AudioPlayer();
                            },
                          ),
                        );
                      },
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            var _timerTime = _timerController.getTime();
                            _timerTime == '10'
                                ? _timerController.restart()
                                : _timerController.start();
                          },
                          icon: isButtonRecording == true
                              ? const FaIcon(FontAwesomeIcons.stop)
                              : const FaIcon(FontAwesomeIcons.solidCircle),
                        ),
                        Text('10 seconds')
                      ],
                    ),
                  ]),
              TextButton(
                child: Text('Player'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return AudioPlayer();
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

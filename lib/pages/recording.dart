import 'dart:async';

import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/models/sound_recorder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import 'audio_player.dart';

class Recording extends StatefulWidget {
  const Recording({Key? key}) : super(key: key);

  @override
  State<Recording> createState() => _RecordingState();
}

class _RecordingState extends State<Recording> with TickerProviderStateMixin {
  final recorder = SoundRecorder();
  bool _isRecording = false;
  AnimationController? _animationController;
  int _currentValue = 0;

  @override
  void initState() {
    super.initState();
    recorder.init();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
  }

  @override
  void dispose() {
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String mood = '';
    String tag = '';
    TextEditingController _moodTextController = TextEditingController();
    TextEditingController _tagTextController = TextEditingController();

    return Scaffold(
      appBar: appBar(context),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              _isRecording ? 'recording...' : 'record',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
            Container(
              padding: EdgeInsets.only(top: 16),
              alignment: Alignment.center,
              child: Lottie.asset(
                'assets/yoga_light.json',
                height: MediaQuery.of(context).size.width * 0.85,
                repeat: false,
                controller: _animationController,
              ),
            ),
            Container(
              child: _currentValue == 0
                  ? null
                  // TODO: style progress bar
                  : FAProgressBar(
                      currentValue: _currentValue,
                      maxValue: 46,
                      size: 20,
                      backgroundColor: Colors.amberAccent,
                      progressColor: Colors.blueAccent,
                      changeColorValue: 32,
                      changeProgressColor: Colors.green,
                    ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 12,
            ),
            Container(
              // Start recording button
              alignment: Alignment.center,
              child: CupertinoButton(
                child: Text(
                  'start recording',
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.white),
                ),
                color: Color.fromRGBO(152, 182, 105, 1),
                onPressed: _isRecording == true
                    ? null
                    : () {
                        _animationController!.forward();

                        setState(() {
                          _isRecording = true;
                        });
                        recorder.record();
                        Timer.periodic(Duration(milliseconds: 100), (timer) {
                          if (_currentValue == 50) {
                            _currentValue = -1;
                            // setState(() {});
                            timer.cancel();
                          }
                          setState(() {
                            _currentValue = _currentValue + 1;
                          });
                        });

                        Timer(
                          Duration(seconds: 5),
                          () async {
                            recorder.stop();
                            await showCupertinoModalPopup(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: Text('tag and mood'),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      _animationController!.reset();
                                      Navigator.of(context).pop();
                                    },
                                    child: FaIcon(FontAwesomeIcons.check),
                                  )
                                ],
                                content: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text('tag'),
                                            padding: EdgeInsets.only(bottom: 5),
                                          ),
                                          CupertinoTextField(
                                            placeholder: 'add a tag',
                                            prefix: Container(
                                                padding: EdgeInsets.all(4),
                                                child: FaIcon(
                                                    FontAwesomeIcons.hashtag)),
                                            autofocus: true,
                                            autocorrect: false,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            maxLength: 15,
                                            maxLengthEnforcement:
                                                MaxLengthEnforcement.enforced,
                                            controller: _moodTextController,
                                            onChanged: (e) =>
                                                mood = _moodTextController.text,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text('mood'),
                                            padding: EdgeInsets.only(bottom: 5),
                                          ),
                                          CupertinoTextField(
                                            placeholder: 'register your mood',
                                            autocorrect: false,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            maxLength: 15,
                                            maxLengthEnforcement:
                                                MaxLengthEnforcement.enforced,
                                            controller: _tagTextController,
                                            onChanged: (e) =>
                                                tag = _tagTextController.text,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                            recorder.updateDB(mood.isNotEmpty ? mood : '',
                                tag.isNotEmpty ? tag : '');
                            _isRecording = false;
                            setState(() {});

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AudioPlayer();
                                },
                              ),
                            );
                          },
                        );
                      },
              ),
            ),
            Container(
              // Player button
              alignment: Alignment.center,
              child: CupertinoButton(
                child: Text(
                  'player',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: _isRecording
                          ? Colors.grey.shade100
                          : Colors.blueAccent),
                ),
                onPressed: _isRecording == true
                    ? null
                    : () {
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
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/models/sound_recorder.dart';
import 'package:audio_journal/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'audio_player.dart';
import 'first_time_user.dart';

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
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
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
    DateTime todaysDate = DateTime.now();
    DateFormat format = DateFormat('EEEE dd MMM');

    String _timeOfTheDay() {
      String time = '';
      if (todaysDate.hour > 5 && todaysDate.hour < 12) {
        time = 'morning';
      } else if (todaysDate.hour > 12 && todaysDate.hour < 18) {
        time = 'afternoon';
      } else if (todaysDate.hour > 18 && todaysDate.hour < 22) {
        time = 'evening';
      } else {
        time = 'night';
      }
      return time;
    }

    return Scaffold(
      appBar: appBar(context),
      body: ListView(
          padding: const EdgeInsets.all(16),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Text(
              format.format(todaysDate).toUpperCase(),
              style: const TextStyle(color: Colors.lightBlueAccent),
            ),
            Text(
              'Good ${_timeOfTheDay()}, \n${sharedPrefs.username}',
              // _isRecording ? '' : 'record',
              // textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
            Container(
              padding: const EdgeInsets.only(top: 16),
              alignment: Alignment.center,
              child: Lottie.asset(
                'assets/yoga_light.json',
                height: MediaQuery.of(context).size.width * 0.85,
                repeat: false,
                controller: _animationController,
              ),
            ),
            // Container(
            //   child: _currentValue == 0
            //       ? null
            //       // TODO: style progress bar
            //       : FAProgressBar(
            //           currentValue: _currentValue,
            //           maxValue: 46,
            //           size: 20,
            //           backgroundColor: Colors.amberAccent,
            //           progressColor: Colors.blueAccent,
            //           changeColorValue: 32,
            //           changeProgressColor: Colors.green,
            //         ),
            // ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 12,
            ),
            Container(
              // Start recording button
              alignment: Alignment.center,
              child: FloatingActionButton(
                child: FaIcon(
                  FontAwesomeIcons.microphone,
                  color: Colors.white.withOpacity(0.85),
                ),
                elevation: 3,
                backgroundColor:
                    !_isRecording ? Colors.blueAccent : Colors.grey,
                // child: CupertinoButton(
                //   child: Text(!_isRecording ? 'start recording' : 'recording...',
                //       style: Theme.of(context).textTheme.headline4!.copyWith(
                //           color: _isRecording ? Colors.grey : Colors.blueAccent)),
                onPressed: _isRecording == true
                    ? null
                    : () {
                        _animationController!.forward();
                        sharedPrefs.todayDate = DateTime.now().day.toString() +
                            DateTime.now().month.toString();

                        setState(() {
                          _isRecording = true;
                        });
                        recorder.record();
                        Timer.periodic(const Duration(milliseconds: 100),
                            (timer) {
                          if (_currentValue == 50) {
                            _currentValue = -1;
                            timer.cancel();
                          }
                          setState(() {
                            _currentValue = _currentValue + 1;
                          });
                        });

                        Timer(
                          const Duration(seconds: 5),
                          () async {
                            recorder.stop();
                            await showCupertinoModalPopup(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: const Text('tag and mood'),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      _animationController!.reset();
                                      Navigator.of(context).pop();
                                    },
                                    child: const FaIcon(FontAwesomeIcons.check),
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
                                            child: const Text('tag'),
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                          ),
                                          CupertinoTextField(
                                            placeholder: 'add a tag',
                                            prefix: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: const FaIcon(
                                                    FontAwesomeIcons.hashtag)),
                                            autofocus: true,
                                            autocorrect: false,
                                            padding: const EdgeInsets.symmetric(
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: const Text('mood'),
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                          ),
                                          CupertinoTextField(
                                            placeholder: 'register your mood',
                                            autocorrect: false,
                                            padding: const EdgeInsets.symmetric(
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
                                  return const AudioPlayer();
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
                          : Colors.lightBlueAccent),
                ),
                onPressed: _isRecording == true
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const AudioPlayer();
                            },
                          ),
                        );
                      },
              ),
            ),
            TextButton(
                onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const FirstTimeUser();
                        },
                      ),
                    ),
                child: const Text('first time user')),
          ]),
    );
  }
}

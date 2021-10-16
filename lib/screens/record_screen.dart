import 'dart:async';

import 'package:audio_journal/models/sound_recorder.dart';
import 'package:audio_journal/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen>
    with TickerProviderStateMixin {
  final recorder = SoundRecorder();
  bool isRecording = false;
  AnimationController? _animationController;
  int _currentValue = 0;
  bool selected = false;

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
    // TextEditingController _moodTextController = TextEditingController();
    TextEditingController _tagTextController = TextEditingController();
    DateTime todaysDate = DateTime.now();
    DateFormat format = DateFormat('EEEE dd MMM');

    String _timeOfTheDay() {
      String time = '';
      if (5 <= todaysDate.hour && todaysDate.hour <= 11) {
        time = 'morning';
      } else if (12 <= todaysDate.hour && todaysDate.hour <= 17) {
        time = 'afternoon';
      } else if (18 <= todaysDate.hour && todaysDate.hour <= 22) {
        time = 'evening';
      } else {
        time = 'night';
      }
      return time;
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Text(
          format.format(todaysDate).toUpperCase(),
          style: const TextStyle(color: Colors.lightBlueAccent),
        ),
        const SizedBox(height: 8),
        SizedBox(
            height: 85,
            child: Text(
              'Good ${_timeOfTheDay()}, \n${sharedPrefs.username}',
              style: Theme.of(context).textTheme.headline1,
            )),
        Container(
          alignment: Alignment.center,
          child: Lottie.asset(
            'assets/yoga_light.json',
            height: MediaQuery.of(context).size.width * 0.85,
            repeat: false,
            controller: _animationController,
          ),
        ),
        FAProgressBar(
          animatedDuration: const Duration(seconds: 5),
          currentValue: _currentValue,
          maxValue: 46,
          size: 5,
          progressColor: Colors.blueAccent.withOpacity(0.1),
          changeColorValue: 20,
          changeProgressColor: Colors.blueAccent.withOpacity(0.75),
        ),
        const SizedBox(
          height: 24,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            elevation: 1,
            primary: !isRecording ? Colors.white : Colors.grey.withOpacity(0.5),
          ),
          child: SizedBox(
            height: 80,
            width: 80,
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.microphone,
                color: !isRecording
                    ? Colors.blueAccent.withOpacity(0.85)
                    : Colors.grey.withOpacity(0.75),
              ),
            ),
          ),
          onPressed: isRecording == true || _currentValue != 0
              ? null
              : () {
                  _animationController!.forward();
                  setState(() {
                    isRecording = true;
                  });
                  _currentValue = 46;
                  sharedPrefs.todayDate = DateTime.now().day.toString() +
                      DateTime.now().month.toString();
                  recorder.record();
                  Timer(
                    const Duration(seconds: 5),
                    () async {
                      recorder.stop();
                      setState(() {
                        _currentValue = 0;
                      });
                      await showCupertinoModalPopup(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: const Text('Assign a tag'),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () {
                                _animationController!.reset();
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor:
                                            Color.fromRGBO(0, 130, 210, 1),
                                        content: Text(
                                            'Your recording has been saved')));
                              },
                              child: const FaIcon(FontAwesomeIcons.check),
                            )
                          ],
                          content: Column(
                            children: [
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CupertinoTextField(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 10),
                                      autofocus: true,
                                      autocorrect: false,
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
                      isRecording = false;
                      setState(() {});
                    },
                  );
                },
        ),
      ],
    );
  }
}

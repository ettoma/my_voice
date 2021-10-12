import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/models/sound_recorder.dart';
import 'package:audio_journal/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
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
  bool selected = false;
  int _selectedIndex = 0;

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

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      appBar: appBar(context),
      body: _selectedIndex == 0
          ? ListView(
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
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      onFinished: () {
                        setState(() {
                          selected = !selected;
                        });
                      },
                      animatedTexts: [
                        TyperAnimatedText(
                          'Good ${_timeOfTheDay()}, \n${sharedPrefs.username}',
                          speed: const Duration(milliseconds: 125),
                          textStyle: Theme.of(context).textTheme.headline1,
                        )
                      ],
                    ),
                  ),
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
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(children: [
                      AnimatedOpacity(
                        opacity: selected ? 1 : 0,
                        duration: const Duration(seconds: 1),
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              elevation: 2,
                              primary: !_isRecording
                                  ? Colors.white
                                  : Colors.grey.withOpacity(0.5),
                            ),
                            child: SizedBox(
                              height: 80,
                              width: 80,
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.microphone,
                                  color: !_isRecording
                                      ? Colors.blueAccent.withOpacity(0.85)
                                      : Colors.grey.withOpacity(0.75),
                                ),
                              ),
                            ),
                            onPressed: _isRecording == true ||
                                    _currentValue != 0
                                ? null
                                : () {
                                    _animationController!.forward();
                                    setState(() {
                                      _isRecording = true;
                                    });
                                    _currentValue = 46;
                                    sharedPrefs.todayDate =
                                        DateTime.now().day.toString() +
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
                                          builder: (context) =>
                                              CupertinoAlertDialog(
                                            title: const Text('Assign a tag'),
                                            actions: [
                                              CupertinoDialogAction(
                                                onPressed: () {
                                                  _animationController!.reset();
                                                  Navigator.of(context).pop();
                                                },
                                                child: const FaIcon(
                                                    FontAwesomeIcons.check),
                                              )
                                            ],
                                            content: Column(
                                              children: [
                                                const SizedBox(height: 12),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CupertinoTextField(
                                                        placeholder:
                                                            'add a tag',
                                                        autofocus: true,
                                                        autocorrect: false,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 5,
                                                                horizontal: 10),
                                                        maxLength: 15,
                                                        maxLengthEnforcement:
                                                            MaxLengthEnforcement
                                                                .enforced,
                                                        controller:
                                                            _tagTextController,
                                                        onChanged: (e) => tag =
                                                            _tagTextController
                                                                .text,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Padding(
                                                //   padding: const EdgeInsets.all(8.0),
                                                //   child: Column(
                                                //     crossAxisAlignment:
                                                //         CrossAxisAlignment.start,
                                                //     children: [
                                                //       Container(
                                                //         child: const Text('mood'),
                                                //         padding:
                                                //             const EdgeInsets.only(
                                                //                 bottom: 5),
                                                //       ),
                                                //       CupertinoTextField(
                                                //         placeholder:
                                                //             'register your mood',
                                                //         autocorrect: false,
                                                //         padding: const EdgeInsets
                                                //                 .symmetric(
                                                //             vertical: 5,
                                                //             horizontal: 10),
                                                //         maxLength: 15,
                                                //         maxLengthEnforcement:
                                                //             MaxLengthEnforcement
                                                //                 .enforced,
                                                //         controller:
                                                //             _moodTextController,
                                                //         onChanged: (e) => mood =
                                                //             _moodTextController.text,
                                                //       ),
                                                //     ],
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        );
                                        recorder.updateDB(
                                            mood.isNotEmpty ? mood : '',
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
                      ),
                    ]),
                  ),
                  Container(
                    // Player button
                    margin: const EdgeInsets.only(top: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                          child: Text(
                            'play',
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                    color: _isRecording
                                        ? Colors.grey.shade100
                                        : Colors.blueGrey,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
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
                        Icon(
                          FontAwesomeIcons.longArrowAltRight,
                          color: _isRecording
                              ? Colors.grey.shade100
                              : Colors.blueGrey,
                        )
                      ],
                    ),
                  ),
                  // TextButton(
                  //     onPressed: () => Navigator.pushReplacement(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) {
                  //               return const FirstTimeUser();
                  //             },
                  //           ),
                  //         ),
                  //     child: const Text('first time user')),
                ])
          : Text('new page'),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.amber,
        items: const [
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.magic), label: 'Play')
        ],
      ),
    );
  }
}

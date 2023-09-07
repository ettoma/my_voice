import 'dart:async';
import 'dart:io';

import 'package:audio_journal/data/audio_file_db.dart';
import 'package:audio_journal/data/audio_model.dart';
import 'package:audio_journal/models/sound_recorder.dart';
import 'package:audio_journal/utils/app_theme.dart';
import 'package:audio_journal/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen>
    with TickerProviderStateMixin {
  String username = sharedPrefs.username;
  final recorder = SoundRecorder();
  bool isRecording = false;
  AnimationController? _animationController;
  int _currentValue = 0;
  bool selected = false;
  String today = DateTime.now().day.toString() +
      DateTime.now().month.toString() +
      DateTime.now().year.toString();
  String latestAudioRecordingDate = '';
  bool isLoading = false;
  final List<String> _selectedAnimation = [
    'assets/man.json',
    'assets/yoga_light.json'
  ];

  int toggleIndex = sharedPrefs.animationPref;
  bool isRecordingCompleted = false;

  List<AudioFile> audioFiles = [];

  Future refreshAudioFileList() async {
    isLoading = true;
    audioFiles = await AudioDatabase.instance.readAllAudioFiles();
    if (audioFiles.isNotEmpty) {
      var latestAudio = DateTime.fromMillisecondsSinceEpoch(
          int.parse(audioFiles[audioFiles.length - 1].fileName));
      latestAudioRecordingDate = latestAudio.day.toString() +
          latestAudio.month.toString() +
          latestAudio.year.toString();
    }
    isLoading = false;
    setState(() {});
  }

  Color? buttonColourNotRecording() {
    if (sharedPrefs.darkThemePreference.isNotEmpty) {
      if (sharedPrefs.darkThemePreference == 'light') {
        return Colors.white;
      } else if (sharedPrefs.darkThemePreference == 'dark') {
        return Colors.grey[800];
      }
    } else if (sharedPrefs.darkThemePreference.isEmpty) {
      if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
        return Colors.grey[800];
      } else {
        return Colors.white;
      }
    }
  }

  Color? iconColourNotRecording() {
    if (sharedPrefs.darkThemePreference.isNotEmpty) {
      if (sharedPrefs.darkThemePreference == 'light') {
        return Colors.blue[400];
      } else if (sharedPrefs.darkThemePreference == 'dark') {
        return Colors.grey[500];
      }
    } else if (sharedPrefs.darkThemePreference.isEmpty) {
      if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
        return Colors.blue[400];
      } else {
        return Colors.grey[500];
      }
    }
  }

  Color? buttonColourRecording() {
    if (sharedPrefs.darkThemePreference.isNotEmpty) {
      if (sharedPrefs.darkThemePreference == 'light') {
        return Colors.grey[400];
      } else if (sharedPrefs.darkThemePreference == 'dark') {
        return Colors.grey[850];
      }
    } else if (sharedPrefs.darkThemePreference.isEmpty) {
      if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
        return Colors.grey[850];
      } else {
        return Colors.grey[400];
      }
    }
  }

  Color? iconColourRecording() {
    if (sharedPrefs.darkThemePreference.isNotEmpty) {
      if (sharedPrefs.darkThemePreference == 'light') {
        return Colors.grey[600];
      } else if (sharedPrefs.darkThemePreference == 'dark') {
        return Colors.grey[750];
      }
    } else if (sharedPrefs.darkThemePreference.isEmpty) {
      if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
        return Colors.grey[750];
      } else {
        return Colors.grey[600];
      }
    }
  }

  @override
  void initState() {
    refreshAudioFileList();
    super.initState();
    recorder.init();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations al = AppLocalizations.of(context)!;
    String mood = '';
    String tag = '';
    TextEditingController _tagTextController = TextEditingController();
    DateTime todaysDate = DateTime.now();
    DateFormat format = DateFormat('dd.MM.yyy');

    String timeOfTheDay() {
      String time = '';
      if (5 <= todaysDate.hour && todaysDate.hour <= 11) {
        time = al.morning;
      } else if (12 <= todaysDate.hour && todaysDate.hour <= 17) {
        time = al.afternoon;
      } else if (18 <= todaysDate.hour && todaysDate.hour <= 21) {
        time = al.evening;
      } else {
        time = al.night;
      }
      return time;
    }

    bool isGenderMale() {
      if (5 <= todaysDate.hour && todaysDate.hour <= 11) {
        return true;
      } else if (12 <= todaysDate.hour && todaysDate.hour <= 17) {
        return true;
      } else if (18 <= todaysDate.hour && todaysDate.hour <= 21) {
        return false;
      } else {
        return false;
      }
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              format.format(todaysDate).toUpperCase(),
              style: const TextStyle(color: Colors.lightBlueAccent),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
              isGenderMale()
                  ? al.greetingIntroMale +
                      al.greetingText(timeOfTheDay()) +
                      '\n$username'
                  : al.greetingIntroFemale +
                      al.greetingText(timeOfTheDay()) +
                      '\n$username',
              style: Theme.of(context).textTheme.headline1),
        ),
        Container(
          child: Lottie.asset(
            _selectedAnimation[toggleIndex],
            height: MediaQuery.of(context).textScaleFactor > 1.25 ? 300 : 350,
            repeat: false,
            controller: _animationController,
          ),
        ),
        FAProgressBar(
          animatedDuration: const Duration(seconds: 10),
          currentValue: double.parse(_currentValue.toString()),
          maxValue: 45,
          size: 5,
          progressColor: Colors.blueAccent.withOpacity(0.75),
        ),
        const SizedBox(
          height: 12,
        ),
        isLoading
            ? const CircularProgressIndicator()
            : latestAudioRecordingDate == today
                ? Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 26),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            al.greatJobToday,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.orangeAccent),
                          ),
                        ),
                        Text(
                          al.comeBackTomorrow,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      elevation: 1,
                      primary: isRecording
                          ? buttonColourRecording()
                          : buttonColourNotRecording(),
                    ),
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: Center(
                        child: FaIcon(FontAwesomeIcons.microphone,
                            color: isRecording
                                ? Colors.grey[600]
                                : Colors.blue[400]),
                      ),
                    ),
                    onPressed: isRecording == true || _currentValue != 0
                        ? null
                        : () {
                            _animationController!.forward();
                            setState(
                              () {
                                isRecording = true;
                              },
                            );
                            _currentValue = 46;
                            recorder.record();
                            Timer(
                              const Duration(seconds: 10),
                              () async {
                                recorder.stop();
                                setState(
                                  () {
                                    _currentValue = 0;
                                  },
                                );
                                Platform.isIOS
                                    // iOS modal
                                    ? await showCupertinoModalPopup(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => CupertinoTheme(
                                          data: CupertinoThemeData(
                                              brightness:
                                                  ThemeProvider().isDarkMode
                                                      ? Brightness.dark
                                                      : Brightness.light),
                                          child: CupertinoAlertDialog(
                                            actions: [
                                              CupertinoDialogAction(
                                                child: const FaIcon(
                                                    FontAwesomeIcons.check),
                                                onPressed: () {
                                                  _animationController!.reset();
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      onVisible: () {
                                                        refreshAudioFileList();
                                                      },
                                                      backgroundColor:
                                                          const Color.fromRGBO(
                                                              0, 130, 210, 1),
                                                      content: Text(
                                                          al.recordingSaved),
                                                    ),
                                                  );
                                                  recorder.updateDB(
                                                      mood.isNotEmpty
                                                          ? mood
                                                          : '',
                                                      tag.isNotEmpty
                                                          ? tag
                                                          : '');
                                                  isRecording = false;
                                                  setState(() {});
                                                },
                                              )
                                            ],
                                            title: Text(al.addTag),
                                            content: CupertinoTextField(
                                              prefix: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12.0),
                                                child: Icon(
                                                    FontAwesomeIcons.hashtag,
                                                    size: 14,
                                                    color: Colors.black54),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 10),
                                              autofocus: true,
                                              autocorrect: false,
                                              maxLength: 15,
                                              maxLengthEnforcement:
                                                  MaxLengthEnforcement.enforced,
                                              controller: _tagTextController,
                                              onChanged: (e) =>
                                                  tag = _tagTextController.text,
                                            ),
                                          ),
                                        ),
                                      )
                                    // Android Modal
                                    : await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: Container(
                                              color: ThemeProvider().isDarkMode
                                                  ? Colors.grey[800]
                                                  : Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 18.0,
                                                        horizontal: 24),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      al.addTag,
                                                      style: TextStyle(
                                                          color: ThemeProvider()
                                                                  .isDarkMode
                                                              ? Colors.white
                                                              : Colors.black),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 12),
                                                      child: TextFormField(
                                                        decoration: InputDecoration(
                                                            counterStyle: TextStyle(
                                                                color: ThemeProvider()
                                                                        .isDarkMode
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black)),
                                                        controller:
                                                            _tagTextController,
                                                        onChanged: (e) => tag =
                                                            _tagTextController
                                                                .text,
                                                        maxLength: 18,
                                                        maxLengthEnforcement:
                                                            MaxLengthEnforcement
                                                                .enforced,
                                                        style: TextStyle(
                                                            color: ThemeProvider()
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black),
                                                      ),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          _animationController!
                                                              .reset();
                                                          Navigator.of(context)
                                                              .pop();
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              onVisible: () {
                                                                refreshAudioFileList();
                                                              },
                                                              backgroundColor:
                                                                  const Color
                                                                      .fromRGBO(
                                                                      0,
                                                                      130,
                                                                      210,
                                                                      1),
                                                              content: Text(al
                                                                  .recordingSaved),
                                                            ),
                                                          );
                                                          recorder.updateDB(
                                                              mood.isNotEmpty
                                                                  ? mood
                                                                  : '',
                                                              tag.isNotEmpty
                                                                  ? tag
                                                                  : '');
                                                          isRecording = false;
                                                          setState(() {});
                                                        },
                                                        icon: const FaIcon(
                                                          FontAwesomeIcons
                                                              .check,
                                                          color:
                                                              Colors.blueAccent,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                              },
                            );
                          },
                  )
      ],
    );
  }
}

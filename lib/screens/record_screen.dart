import 'dart:async';

import 'package:audio_journal/data/audio_file_db.dart';
import 'package:audio_journal/data/audio_model.dart';
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
      } else if (18 <= todaysDate.hour && todaysDate.hour <= 21) {
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
        SizedBox(
          height: 80,
          child: Text(
            'Good ${_timeOfTheDay()}, \n$username',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        Container(
          child: Lottie.asset(
            _selectedAnimation[toggleIndex],
            height: MediaQuery.of(context).size.width * 0.85,
            repeat: false,
            controller: _animationController,
          ),
        ),
        FAProgressBar(
          animatedDuration: const Duration(seconds: 10),
          currentValue: _currentValue,
          maxValue: 45,
          size: 5,
          progressColor: Colors.blueAccent.withOpacity(0.75),
        ),
        const SizedBox(
          height: 20,
        ),
        isLoading
            ? const LinearProgressIndicator()
            // ! to enable recording everyday
            : latestAudioRecordingDate == today
                ? Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 26),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: const Text(
                            'Great job today!',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Text(
                          'Come back tomorrow to record a new audio',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      elevation: 1,
                      primary: !isRecording
                          ? Colors.white
                          : Colors.grey.withOpacity(0.5),
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
                            setState(
                              () {
                                isRecording = true;
                              },
                            );
                            _currentValue = 46;
                            recorder.record();
                            Timer(
                              const Duration(seconds: 1),
                              () async {
                                recorder.stop();
                                setState(
                                  () {
                                    _currentValue = 0;
                                  },
                                );
                                await showCupertinoModalPopup(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
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
                                              content: const Text(
                                                  'Your recording has been saved'),
                                            ),
                                          );
                                          recorder.updateDB(
                                              mood.isNotEmpty ? mood : '',
                                              tag.isNotEmpty ? tag : '');
                                          isRecording = false;
                                          setState(() {});
                                        },
                                      )
                                    ],
                                    title: const Text(
                                        'Enter a tag for your audio'),
                                    content: CupertinoTextField(
                                      prefix: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: Icon(FontAwesomeIcons.hashtag,
                                            size: 14, color: Colors.black54),
                                      ),
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
                                  ),
                                );
                              },
                            );
                          },
                  )
      ],
    );
  }
}

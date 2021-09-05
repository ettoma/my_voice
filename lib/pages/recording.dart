import 'dart:async';

import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/models/sound_recorder.dart';
import 'package:flutter/cupertino.dart';
// import 'package:audio_journal/utils/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import 'audio_player.dart';

class Recording extends StatefulWidget {
  const Recording({Key? key}) : super(key: key);

  @override
  State<Recording> createState() => _RecordingState();
}

class _RecordingState extends State<Recording> with TickerProviderStateMixin {
  final recorder = SoundRecorder();
  bool _isButtonDisabled = false;
  int number = 5;
  Timer? animationTimer;
  bool animate = false;
  double animatedWidth = 300.0;
  AnimationController? _animationController;

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
        child: Column(
          children: [
            Text(
              'record',
              style: Theme.of(context).textTheme.headline1,
            ),
            Lottie.asset(
              'assets/yoga_light.json',
              repeat: false,
              controller: _animationController,
            ),
            CupertinoButton(
              color: Colors.greenAccent,
              onPressed: _isButtonDisabled == true
                  ? null
                  : () {
                      _animationController!.forward();
                      _isButtonDisabled = true;
                      setState(() {});
                      recorder.record();
                      Timer(
                        Duration(seconds: 5),
                        () async {
                          recorder.stop();
                          await showCupertinoDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: Text('save'),
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
                                  CupertinoTextField(
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
                                  CupertinoTextField(
                                    controller: _tagTextController,
                                    onChanged: (e) =>
                                        tag = _tagTextController.text,
                                  ),
                                ],
                              ),
                            ),
                          );
                          recorder.updateDB(mood.isNotEmpty ? mood : '',
                              tag.isNotEmpty ? tag : '');
                          _isButtonDisabled = false;
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
              child: Text('start recording'),
            ),
            CupertinoButton(
              child: Text('player'),
              onPressed: _isButtonDisabled == true
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
            )
          ],
        ),
      ),
    );
  }
}

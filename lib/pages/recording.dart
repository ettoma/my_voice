import 'dart:async';

import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/models/sound_recorder.dart';
import 'package:audio_journal/utils/colours.dart';
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
  bool _isButtonDisabled = false;
  int number = 5;
  Timer? animationTimer;

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
              Container(
                height: 200,
                width: 200,
                color: Colors.amberAccent,
                child: Center(child: Text(number.toString())),
              ),
              TextButton(
                onPressed: _isButtonDisabled == true
                    ? null
                    : () {
                        _isButtonDisabled = true;
                        setState(() {});
                        recorder.record();
                        animationTimer =
                            Timer.periodic(Duration(seconds: 1), (timer) {
                          setState(() {
                            number = number - 1;
                          });
                          if (number == 0) {
                            animationTimer!.cancel();
                            number = 5;
                          }
                        });
                        Timer(
                          Duration(seconds: 5),
                          () async {
                            recorder.stop();
                            await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => Dialog(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
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
                                        decoration: InputDecoration(
                                            labelText: 'Tag',
                                            errorText:
                                                'Please fill in the field'),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: FaIcon(FontAwesomeIcons.check),
                                      )
                                    ],
                                  ),
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
              TextButton(
                child: Text('Player'),
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
      ),
    );
  }
}

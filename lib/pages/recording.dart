import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/models/sound_recorder.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class Recording extends StatefulWidget {
  const Recording({Key? key}) : super(key: key);

  @override
  State<Recording> createState() => _RecordingState();
}

class _RecordingState extends State<Recording> {
  final recorder = SoundRecorder();
  final CountDownController _controller = CountDownController();
  final int _duration = 10;

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
    return Scaffold(
      appBar: appBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24.0, left: 8, right: 8),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularCountDownTimer(
                    controller: _controller,
                    autoStart: false,
                    width: 200,
                    height: 200,
                    duration: _duration,
                    fillColor: Colors.blueAccent,
                    ringColor: Colors.orangeAccent),
                IconButton(
                  onPressed: () async {
                    final _time = _controller.getTime();
                    final isRecording = await recorder.toggleRecording();
                    setState(() {});
                  },
                  icon: const FaIcon(FontAwesomeIcons.recordVinyl),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

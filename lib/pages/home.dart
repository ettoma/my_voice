import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/models/floating_action_button.dart';
import 'package:audio_journal/pages/recording.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          heightFactor: 10,
          child: Text(
            'Take 10 seconds for yourself',
            style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w400,
                fontFamily: 'Gill Sans'),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: floatingActionButton(context, const Recording()),
    );
  }
}

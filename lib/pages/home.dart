import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          heightFactor: 8,
          child: Text(
            'What do you want today to be remembered for?',
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 30),
        height: 115,
        width: 115,
        child: FittedBox(
          child: FloatingActionButton(
              backgroundColor: Color.fromRGBO(141, 255, 205, 0.5),
              onPressed: () {},
              elevation: 1,
              child: const FaIcon(FontAwesomeIcons.microphone)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget floatingActionButton(context, routePage) {
  return Container(
    margin: const EdgeInsets.only(bottom: 30),
    height: 115,
    width: 115,
    child: FittedBox(
      child: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(141, 255, 205, 0.5),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return routePage;
            }));
          },
          elevation: 1,
          child: const FaIcon(FontAwesomeIcons.microphone)),
    ),
  );
}

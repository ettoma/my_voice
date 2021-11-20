import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'daily_quote.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const DailyQuote();
          },
        ),
      );
    });
    return Semantics(
      image: true,
      label: 'My voice splash screen',
      child: Scaffold(
        body: Center(
          child: AnimatedTextKit(
            isRepeatingAnimation: false,
            animatedTexts: [
              TypewriterAnimatedText('my voice',
                  textStyle: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontSize: 46),
                  speed: const Duration(milliseconds: 350))
            ],
          ),
        ),
      ),
    );
  }
}

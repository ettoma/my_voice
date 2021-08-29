import 'dart:async';

import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/pages/recording.dart';
import 'package:audio_journal/utils/colours.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> quotes = [
      {
        'quote':
            '“The happiness of your life depends on the quality of your thoughts”',
        'author': 'Marcus Aurelius'
      },
      {'quote': 'You wanna die?', 'author': 'Jinseo Kim'}
    ];
    int randomQuoteInt = Random().nextInt(quotes.length);

    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const Recording();
          },
        ),
      );
    });
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          // color: Colors.amberAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                quotes[randomQuoteInt]['quote'].toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 14,
                width: 1,
                color: Colors.black,
              ),
              Text(
                quotes[randomQuoteInt]['author'].toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black87),
              ),
              SizedBox(
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

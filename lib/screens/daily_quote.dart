import 'dart:async';

import 'package:audio_journal/data/quotes.dart';
import 'package:audio_journal/screens/first_time_user.dart';
import 'package:audio_journal/screens/home.dart';
import 'package:audio_journal/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class DailyQuote extends StatelessWidget {
  const DailyQuote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int randomQuoteInt = Random().nextInt(Quotes().quotes.length);

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return sharedPrefs.username.isEmpty
                ? const FirstTimeUser()
                : const Home();
          },
        ),
      );
    });
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                Quotes().quotes[randomQuoteInt]['quote'].toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                Quotes().quotes[randomQuoteInt]['author'].toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(fontSize: 24, color: Colors.green.shade800),
              ),
              // const SizedBox(
              //   height: 150,
            ],
          ),
        ),
      ),
    );
  }
}

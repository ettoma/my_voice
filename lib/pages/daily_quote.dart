// import 'dart:async';

import 'package:audio_journal/data/quotes.dart';
// import 'package:audio_journal/models/app_bar.dart';
// import 'package:audio_journal/pages/recording.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class DailyQuote extends StatelessWidget {
  const DailyQuote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quotes = Quotes();
    int randomQuoteInt = Random().nextInt(quotes.quotes.length);

    // Timer(Duration(seconds: 5), () {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) {
    //         return const Recording();
    //       },
    //     ),
    //   );
    // });
    return Scaffold(
      // appBar: appBar(context),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          // color: Colors.amberAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                quotes.quotes[randomQuoteInt]['quote'].toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 14,
                width: 1,
                color: Colors.black,
              ),
              Text(
                quotes.quotes[randomQuoteInt]['author'].toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3,
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

import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/pages/recording.dart';
import 'package:audio_journal/utils/colours.dart';
import 'package:flutter/material.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                '“The happiness of your life depends on the quality of your thoughts”',
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
                'Marcus Aurelius',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black87),
              ),
              SizedBox(
                height: 150,
              ),
              Container(
                decoration: BoxDecoration(
                    color: AppColours().buttonBackground,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                width: MediaQuery.of(context).size.width * 0.60,
                height: 50,
                child: TextButton(
                  child: Text(
                    'GET STARTED',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const Recording();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

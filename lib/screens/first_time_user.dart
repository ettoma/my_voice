import 'dart:async';

import 'package:audio_journal/screens/instructions.dart';
import 'package:audio_journal/utils/notification_service.dart';
import 'package:audio_journal/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FirstTimeUser extends StatefulWidget {
  const FirstTimeUser({Key? key}) : super(key: key);

  @override
  _FirstTimeUserState createState() => _FirstTimeUserState();
}

class _FirstTimeUserState extends State<FirstTimeUser> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: sharedPrefs.username == ''
            ? <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'What\'s your name?',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CupertinoTextField.borderless(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                  autofocus: true,
                  textAlign: TextAlign.center,
                  autocorrect: false,
                  controller: controller,
                  maxLength: 13,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black),
                  onEditingComplete: () {
                    if (controller.text == '') {
                      return;
                    } else {
                      sharedPrefs.username = controller.text.trim();
                      setState(() {});
                      Timer(const Duration(seconds: 5), () {
                        NotificationService().scheduleDailyNotification();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return const Instructions();
                        }));
                      });
                    }
                  },
                ),
              ]
            : <Widget>[
                Center(
                  child: Text(
                    'Welcome,\n${sharedPrefs.username}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(fontSize: 34),
                  ),
                ),
              ],
      ),
    );
  }
}

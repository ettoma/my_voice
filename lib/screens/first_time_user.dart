import 'dart:async';

import 'package:audio_journal/screens/home.dart';
import 'package:audio_journal/screens/instructions.dart';
import 'package:audio_journal/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FirstTimeUser extends StatefulWidget {
  const FirstTimeUser({Key? key}) : super(key: key);
  // String? name;

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
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 34),
                  onEditingComplete: () {
                    if (controller.text == '') {
                      return;
                    } else {
                      sharedPrefs.username = controller.text;
                      setState(() {});
                      Timer(const Duration(seconds: 5), () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return const Instructions();
                        }));
                      });
                    }
                  },
                ),
                IconButton(
                  onPressed: () => sharedPrefs.clear(),
                  icon: const FaIcon(FontAwesomeIcons.blind),
                )
              ]
            : <Widget>[
                Center(
                  child: Text(
                    'Welcome,\n${sharedPrefs.username.trimRight()}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(fontSize: 34),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    sharedPrefs.clear();
                    setState(() {});
                  },
                  icon: const FaIcon(FontAwesomeIcons.blind),
                )
              ],
      ),
    );
  }
}

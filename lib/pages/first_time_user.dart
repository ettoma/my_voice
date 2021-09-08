import 'package:audio_journal/data/app_state.dart';
import 'package:audio_journal/models/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstTimeUser extends StatefulWidget {
  const FirstTimeUser({Key? key}) : super(key: key);

  @override
  _FirstTimeUserState createState() => _FirstTimeUserState();
}

class _FirstTimeUserState extends State<FirstTimeUser> {
  TextEditingController _controller = TextEditingController();
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    // getStoredData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Center(
          child: Column(
        children: [
          Text(
            'What\'s your name?',
            style: Theme.of(context).textTheme.headline2,
          ),
          TextFormField(
            textAlign: TextAlign.center,
            autocorrect: false,
            controller: _controller,
          ),
          IconButton(
              onPressed: () => _prefs!.setString('name', _controller.text),
              icon: FaIcon(FontAwesomeIcons.save))
        ],
      )),
    );
  }
}

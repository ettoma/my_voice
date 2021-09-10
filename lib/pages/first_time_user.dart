import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
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
      appBar: appBar(context),
      body: Column(
        children: [
          Text(
            'What\'s your name?',
            style: Theme.of(context).textTheme.headline2,
          ),
          TextFormField(
            textAlign: TextAlign.center,
            autocorrect: false,
            controller: controller,
          ),
          IconButton(
            onPressed: () => sharedPrefs.username = controller.text,
            icon: const FaIcon(FontAwesomeIcons.save),
          ),
          IconButton(
            onPressed: () => sharedPrefs.clear(),
            icon: const FaIcon(FontAwesomeIcons.blind),
          )
        ],
      ),
    );
  }
}

import 'package:audio_journal/models/app_bar.dart';
import 'package:flutter/material.dart';

class FirstTimeUser extends StatefulWidget {
  const FirstTimeUser({Key? key}) : super(key: key);

  @override
  _FirstTimeUserState createState() => _FirstTimeUserState();
}

class _FirstTimeUserState extends State<FirstTimeUser> {
  TextEditingController _controller = TextEditingController();

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
              onChanged: (_) => print(_controller.text),

              // TODO: Implement shared preferences save
            ),
          ],
        ),
      ),
    );
  }
}

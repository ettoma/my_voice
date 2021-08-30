import 'package:audio_journal/pages/get_started.dart';
import 'package:audio_journal/pages/recording.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          backgroundColor: Color.fromRGBO(250, 249, 249, 1),
          fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      title: 'my voice',
      // home: GetStarted(),
      home: Recording(),
    );
  }
}

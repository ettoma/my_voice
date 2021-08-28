import 'package:audio_journal/data/audio_file_model.dart';
import 'package:audio_journal/pages/get_started.dart';
import 'package:audio_journal/pages/recording.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AudioFileModel(),
      child: MaterialApp(
        theme: ThemeData(
            backgroundColor: Color.fromRGBO(250, 249, 249, 1),
            fontFamily: 'Poppins'),
        debugShowCheckedModeBanner: false,
        title: 'my voice',
        home: GetStarted(),
      ),
    );
  }
}

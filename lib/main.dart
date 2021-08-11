import 'package:audio_journal/data/audio_file_model.dart';
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
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: Home(),
      ),
    );
  }
}

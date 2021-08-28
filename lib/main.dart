import 'package:audio_journal/data/audio_file_model.dart';
import 'package:audio_journal/pages/get_started.dart';
import 'package:audio_journal/pages/recording.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isFirstTimeUser = true;
  Directory? directory;
  List<FileSystemEntity>? file;

  void getDirectory() async {
    directory = await getApplicationDocumentsDirectory();
    file = directory!.listSync(recursive: true);
    if (file!.contains('.db')) {
      print('ok');
    } else {
      print('no');
    }
  }

  @override
  void initState() {
    getDirectory();
  }

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

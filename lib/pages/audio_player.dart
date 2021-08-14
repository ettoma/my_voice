import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/models/player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_journal/data/audio_file_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioPlayer extends StatefulWidget {
  const AudioPlayer({Key? key}) : super(key: key);

  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  final player = SoundPlayer();
  List parsed = [];

  List<FileSystemEntity>? file;
  Directory? directory;

  void getDirectory() async {
    directory = await getApplicationDocumentsDirectory();
    file = directory!.listSync(recursive: true);
  }

  void getFilesFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    parsed = jsonDecode(prefs.getStringList('fileList').toString())
        .cast<Map<String, dynamic>>();
    setState(() {
      parsed.map<RecordedFile>((json) => RecordedFile.fromJson(json)).toList();
    });
  }

  @override
  void initState() {
    player.init();
    super.initState();
    getDirectory();
    getFilesFromStorage();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<AudioFileModel>(context);
    final format = DateFormat('dd.MM.yyyy HH:mm');

    return Scaffold(
      appBar: appBar(),
      body: parsed.isEmpty
          ? const Center(
              child: Text('No audio files to play'),
            )
          : ListView.separated(
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(format
                            .format(DateTime.fromMillisecondsSinceEpoch(
                                int.parse(parsed[index]['fileName'])))
                            .toString()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(parsed[index]['tag']),
                            Text(parsed[index]['mood'])
                          ],
                        )
                      ],
                    ),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.play),
                      onPressed: () async {
                        await player.togglePlaying(
                            whenFinished: () => setState(() {}),
                            fileName:
                                directory!.uri.toFilePath(windows: false) +
                                    parsed[index]['fileName'] +
                                    '.aac');
                        setState(() {});
                      },
                    ),
                    IconButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          final targetFile = File(
                              "${directory!.path}/${parsed[index]['fileName']}.aac");
                          targetFile.deleteSync(recursive: true);
                          parsed.remove(parsed[index]);
                          // var fileListStorage = prefs.getStringList('fileList');
                          // fileListStorage!.remove(parsed[index]);
                          // prefs.setStringList('fileList', parsed);
                          setState(() {});
                        },
                        icon: const FaIcon(FontAwesomeIcons.trashAlt))
                  ],
                );
              },
              separatorBuilder: (context, index) => Container(height: 8),
              itemCount: parsed.length),
    );
  }
}

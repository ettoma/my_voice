import 'dart:io';

import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/models/player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';

class AudioPlayer extends StatefulWidget {
  const AudioPlayer({Key? key}) : super(key: key);

  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  final player = SoundPlayer();
  List<FileSystemEntity>? file;
  List fileNames = [];
  Directory? directory;

  void getDirectory() async {
    directory = await getApplicationDocumentsDirectory();
    file = directory!.listSync();
    file!.remove('.Trash');
    // file!.sort((a,b) => a > b);
    setState(
      () {
        for (var element in file!) {
          if (element.path.contains('.Trash')) {
          } else {
            fileNames.add(element.path.split('/').last);
          }
        }
        getListFiles();
      },
    );
  }

  ListView getListFiles() {
    return ListView.builder(
      itemCount: fileNames.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                fileNames[index],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              IconButton(
                onPressed: () async {
                  await player.togglePlaying(
                      whenFinished: () => setState(() {}),
                      fileName: directory!.uri.toFilePath(windows: false) +
                          fileNames[index]);
                  setState(() {});
                },
                icon: const FaIcon(
                  FontAwesomeIcons.play,
                  size: 18,
                  color: Colors.black38,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    player.init();
    getDirectory();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          Expanded(child: getListFiles()),
        ],
      ),
    );
  }
}

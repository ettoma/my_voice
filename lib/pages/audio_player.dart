import 'dart:io';
import 'package:intl/intl.dart';

import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/models/player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_journal/data/audio_file_model.dart';
import 'package:provider/provider.dart';

class AudioPlayer extends StatefulWidget {
  const AudioPlayer({Key? key}) : super(key: key);

  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  final player = SoundPlayer();

  List<FileSystemEntity>? file;
  List fileURLs = [];
  List fileNames = [];
  Directory? directory;
  // AudioFiles audioFileList = AudioFiles();
  List<RecordedFile>? fileData;

  void getDirectory() async {
    directory = await getApplicationDocumentsDirectory();
    file = directory!.listSync(recursive: true);
    // fileData = audioFileList.fileList;

    setState(
      () {
        // for (var element in fileData!) {}
        // for (var element in file!) {
        //   if (element.path.contains('.Trash')) {
        //   } else {
        //     String fileName = element.path.split('/').last.split('.aac').first;
        //     fileURLs.add(fileName);
        //     DateTime parsedDate =
        //         DateTime.fromMillisecondsSinceEpoch(int.parse(fileName));
        //     final format = DateFormat('dd.MM.yyyy HH:mm');
        //     final formatDate = format.format(parsedDate);
        //     fileNames.add(formatDate);
        //   }
        // }
        // fileData!.map((e) => fileNames.add(e.fileName));
      },
    );
    // fileData!.map(
    //   (e) {
    //     DateTime parsedDate = DateTime.fromMillisecondsSinceEpoch(1);
    //     final format = DateFormat('dd.MM.yyyy HH:mm');
    //     final formatDate = format.format(parsedDate);
    //     fileNames.add(formatDate);
    //   },
    // );
    // for (var element in file!) {
    //   if (element.path.contains('.Trash')) {
    //   } else {
    //     String fileName = element.path.split('/').last.split('.aac').first;
    //     fileURLs.add(fileName);
    //   }
    // }

    // getListFiles();
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
                          fileURLs[index] +
                          '.aac');
                  setState(() {});
                },
                icon: const FaIcon(
                  FontAwesomeIcons.play,
                  size: 18,
                  color: Colors.black38,
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      final targetFile =
                          File("${directory!.path}/${fileURLs[index]}.aac");
                      targetFile.deleteSync(recursive: true);
                      fileURLs.remove(fileURLs[index]);
                      fileNames.remove(fileNames[index]);
                    });
                  },
                  icon: const FaIcon(FontAwesomeIcons.trashAlt))
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
    final provider = Provider.of<AudioFileModel>(context);
    final files = provider.fileList;
    return Scaffold(
      appBar: appBar(),
      // body: Column(
      //   children: [
      //     Expanded(
      //         child: fileNames.isEmpty
      //             ? const Text('Go record something')
      //             : getListFiles()),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return Text(files[index].fileName);
          },
          separatorBuilder: (context, index) => Container(height: 8),
          itemCount: files.length),
    );
  }
}

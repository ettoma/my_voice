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
  var parsed;

  List<FileSystemEntity>? file;
  Directory? directory;

  void getDirectory() async {
    directory = await getApplicationDocumentsDirectory();
    file = directory!.listSync(recursive: true);
  }

  void getFilesFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var parsed = jsonDecode(prefs.getStringList('fileList').toString())
        .cast<Map<String, dynamic>>();
    parsed.map<RecordedFile>((json) => RecordedFile.fromJson(json)).toList();
    // https://flutter.dev/docs/cookbook/networking/background-parsing
    // return parsed;
  }

  @override
  void initState() {
    super.initState();
    player.init();
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
    final provider = Provider.of<AudioFileModel>(context);
    final files = parsed;
    final format = DateFormat('dd.MM.yyyy HH:mm');

    return Scaffold(appBar: appBar(), body: Text(files[0]['fileName'])
        // body: files.isEmpty
        //     ? const Center(
        //         child: Text('No audio files to play'),
        //       )
        //     : ListView.separated(
        //         itemBuilder: (context, index) {
        //           return Row(
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Column(
        //                 children: [
        //                   Text(format
        //                       .format(DateTime.fromMillisecondsSinceEpoch(
        //                           int.parse(files![index]['fileName'])))
        //                       .toString()),
        //                   Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                     mainAxisSize: MainAxisSize.max,
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     children: [
        //                       // Text(files[index].tag),
        //                       // Text(files[index].mood)
        //                     ],
        //                   )
        //                 ],
        //               ),
        //               IconButton(
        //                 icon: const FaIcon(FontAwesomeIcons.play),
        //                 onPressed: () async {
        //                   await player.togglePlaying(
        //                       whenFinished: () => setState(() {}),
        //                       fileName:
        //                           directory!.uri.toFilePath(windows: false) +
        //                               files[index].fileName +
        //                               '.aac');
        //                   setState(() {});
        //                 },
        //               ),
        //               IconButton(
        //                   onPressed: () {
        //                     setState(() {
        //                       final targetFile = File(
        //                           "${directory!.path}/${files[index].fileName}.aac");
        //                       targetFile.deleteSync(recursive: true);
        //                       files.remove(files[index]);
        //                     });
        //                   },
        //                   icon: const FaIcon(FontAwesomeIcons.trashAlt))
        //             ],
        //           );
        //         },
        //         separatorBuilder: (context, index) => Container(height: 8),
        //         itemCount: files.length),
        );
  }
}

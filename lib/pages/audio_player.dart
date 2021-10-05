import 'dart:io';
import 'package:audio_journal/data/audio_file_db.dart';
import 'package:audio_journal/data/audio_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

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
  List<AudioFile> audioFiles = [];
  bool _isLoading = false;
  Color color = Colors.transparent;

  final player = SoundPlayer();

  List<FileSystemEntity>? file;
  Directory? directory;

  void getDirectory() async {
    directory = await getApplicationDocumentsDirectory();
    file = directory!.listSync(recursive: true);
  }

  @override
  void initState() {
    player.init();
    super.initState();
    getDirectory();
    refreshAudioFileList();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future refreshAudioFileList() async {
    setState(() => _isLoading = true);
    audioFiles = await AudioDatabase.instance.readAllAudioFiles().whenComplete(
      () {
        setState(() => _isLoading = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('dd.MM.yyyy HH:mm');

    return Scaffold(
      appBar: appBar(context),
      body: Column(
        children: [
          // Text(
          //   'play',
          //   style: Theme.of(context).textTheme.headline1,
          // ),
          const SizedBox(
            height: 24,
          ),
          Expanded(
            child: audioFiles.isEmpty
                ? const Center(
                    child: Text('No audio files to play'),
                  )
                : Align(
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                        shrinkWrap: true,
                        // reverse: true,
                        itemBuilder: (context, index) {
                          final audio = audioFiles[index];
                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              await showCupertinoModalPopup(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  title: const Text(
                                    'Are you sure?',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  content: const Text('This can\'t be undone',
                                      style: TextStyle(fontSize: 16)),
                                  actions: [
                                    CupertinoDialogAction(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const FaIcon(
                                            FontAwesomeIcons.times)),
                                    CupertinoDialogAction(
                                      onPressed: () async {
                                        await AudioDatabase.instance
                                            .delete(audioFiles[index].id!);
                                        final targetFile = File(
                                            "${directory!.path}/${audioFiles[index].fileName}.aac");
                                        targetFile.deleteSync(recursive: true);
                                        Navigator.of(context).pop();
                                      },
                                      child:
                                          const FaIcon(FontAwesomeIcons.check),
                                    ),
                                  ],
                                ),
                              );
                              refreshAudioFileList();
                            },
                            onDismissed: (direction) {
                              AudioDatabase.instance
                                  .delete(audioFiles[index].id!);
                              final targetFile = File(
                                  "${directory!.path}/${audioFiles[index].fileName}.aac");
                              targetFile.deleteSync(recursive: true);
                              audioFiles.removeAt(index);
                              setState(() {});
                            },
                            key: Key(audioFiles[index].id.toString()),
                            background: stackBehindDismiss(),
                            child: InkWell(
                              // highlightColor: Colors.lightBlueAccent,
                              // focusColor: Colors.lightBlueAccent,
                              splashColor: Colors.lightBlueAccent,
                              onTap: () async {
                                await player.togglePlaying(
                                    whenFinished: () {
                                      setState(() {});
                                    },
                                    fileName: directory!.uri
                                            .toFilePath(windows: false) +
                                        audioFiles[index].fileName +
                                        '.aac');
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color:
                                                Colors.grey.withOpacity(0.2)))),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                margin: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 40),
                                      child: Text(
                                          format.format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  int.parse(audio.fileName
                                                      .split('.aac')
                                                      .first))),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 40),
                                      child: Row(
                                        children: [
                                          // Text(audio.mood),
                                          Text('#${audio.tag}',
                                              style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: audioFiles.length),
                  ),
          ),
        ],
      ),
    );
  }
}

Widget stackBehindDismiss() {
  return Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 20.0),
    color: Colors.red,
    child: const Icon(
      Icons.delete,
      color: Colors.white,
    ),
  );
}

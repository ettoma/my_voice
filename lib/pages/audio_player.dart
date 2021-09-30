import 'dart:io';
import 'package:audio_journal/data/audio_file_db.dart';
import 'package:audio_journal/data/audio_model.dart';
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
      // TODO: style this page
      appBar: appBar(context),
      body: Column(
        children: [
          Text(
            'play',
            style: Theme.of(context).textTheme.headline1,
          ),
          const SizedBox(
            height: 24,
          ),
          Expanded(
            child: audioFiles.isEmpty
                ? const Center(
                    child: Text('No audio files to play'),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      final audio = audioFiles[index];
                      return Dismissible(
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => Dialog(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    const Text('Are you sure?'),
                                    IconButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        icon: const FaIcon(
                                            FontAwesomeIcons.times)),
                                    IconButton(
                                      onPressed: () async {
                                        await AudioDatabase.instance
                                            .delete(audioFiles[index].id!);
                                        final targetFile = File(
                                            "${directory!.path}/${audioFiles[index].fileName}.aac");
                                        targetFile.deleteSync(recursive: true);
                                        Navigator.of(context).pop();
                                      },
                                      icon:
                                          const FaIcon(FontAwesomeIcons.check),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                          refreshAudioFileList();
                        },
                        onDismissed: (direction) {
                          AudioDatabase.instance.delete(audioFiles[index].id!);
                          final targetFile = File(
                              "${directory!.path}/${audioFiles[index].fileName}.aac");
                          targetFile.deleteSync(recursive: true);
                          audioFiles.removeAt(index);
                          setState(() {});
                        },
                        key: Key(audioFiles[index].id.toString()),
                        background: stackBehindDismiss(),
                        child: ElevatedButton(
                          // style: ButtonStyle(
                          //     padding: MaterialStateProperty.all(),
                          //     backgroundColor: MaterialStateColor.resolveWith(
                          //         (states) => Colors.white),
                          //     foregroundColor: MaterialStateColor.resolveWith(
                          //         (states) => Colors.black)),
                          onPressed: () async {
                            await player.togglePlaying(
                                whenFinished: () {
                                  setState(() {});
                                },
                                fileName:
                                    directory!.uri.toFilePath(windows: false) +
                                        audioFiles[index].fileName +
                                        '.aac');
                            setState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(format.format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(audio.fileName
                                                .split('.aac')
                                                .first)))),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text('#' + audio.tag),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(audio.mood)
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      // TODO: fix icon when playing
                                      icon:
                                          player.isPlaying == false //Not ideal
                                              ? FaIcon(FontAwesomeIcons.play)
                                              : FaIcon(FontAwesomeIcons.pause),
                                      onPressed: () async {
                                        await player.togglePlaying(
                                            whenFinished: () {
                                              setState(() {});
                                            },
                                            fileName: directory!.uri.toFilePath(
                                                    windows: false) +
                                                audioFiles[index].fileName +
                                                '.aac');
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: audioFiles.length),
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

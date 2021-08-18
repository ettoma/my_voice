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
  bool isLoading = false;

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
    setState(() => isLoading = true);
    this.audioFiles =
        await AudioDatabase.instance.readAllAudioFiles().whenComplete(
      () {
        setState(() => isLoading = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('dd.MM.yyyy HH:mm');

    return Scaffold(
      appBar: appBar(),
      body: audioFiles.isEmpty
          ? const Center(
              child: Text('No audio files to play'),
            )
          : ListView.separated(
              itemBuilder: (context, index) {
                final audio = audioFiles[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(format.format(DateTime.fromMillisecondsSinceEpoch(
                            int.parse(audio.fileName.split('.aac').first)))),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('#' + audio.tag),
                            SizedBox(
                              width: 8,
                            ),
                            Text(audio.mood)
                          ],
                        )
                      ],
                    ),
                    IconButton(
                      icon: player.isPlaying == false //Not ideal
                          ? FaIcon(FontAwesomeIcons.play)
                          : FaIcon(FontAwesomeIcons.pause),
                      onPressed: () async {
                        await player.togglePlaying(
                            whenFinished: () => setState(() {}),
                            fileName:
                                directory!.uri.toFilePath(windows: false) +
                                    audioFiles[index].fileName +
                                    '.aac');
                        setState(() {});
                      },
                    ),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.trash),
                      onPressed: () async {
                        await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => Dialog(
                            child: Container(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Text('Are you sure?'),
                                  IconButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      icon: FaIcon(FontAwesomeIcons.times)),
                                  IconButton(
                                    onPressed: () async {
                                      await AudioDatabase.instance
                                          .delete(audioFiles[index].id!);
                                      final targetFile = File(
                                          "${directory!.path}/${audioFiles[index].fileName}.aac");
                                      targetFile.deleteSync(recursive: true);
                                      Navigator.of(context).pop();
                                    },
                                    icon: FaIcon(FontAwesomeIcons.check),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                        refreshAudioFileList();
                      },
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) => Container(height: 8),
              itemCount: audioFiles.length),
    );
  }
}

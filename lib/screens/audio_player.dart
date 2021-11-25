import 'dart:io';
import 'package:audio_journal/data/audio_file_db.dart';
import 'package:audio_journal/data/audio_model.dart';
import 'package:audio_journal/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
  List<AudioFile> reversedAudioFileList = [];
  List<AudioFile> foundFilesWithTag = [];
  bool _isLoading = false;
  Color color = Colors.transparent;
  TextEditingController controller = TextEditingController(text: '');

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
    reversedAudioFileList = audioFiles.reversed.toList();
    foundFilesWithTag = reversedAudioFileList;
  }

  void filterListPerTag(String enteredTag) {
    List<AudioFile> results = [];
    if (enteredTag.isEmpty) {
      results = reversedAudioFileList;
    } else {
      results = reversedAudioFileList
          .where((audioFile) =>
              audioFile.tag.toLowerCase().contains(enteredTag.toLowerCase()))
          .toList();
    }

    setState(() {
      foundFilesWithTag = results;
    });
  }

  //! TODO: update tag of existing files

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('dd.MM.yyyy HH:mm');

    return _isLoading == true
        ? Center(
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: const CircularProgressIndicator()))
        : audioFiles.isEmpty
            ? Center(
                child: Text(
                  'No recordings yet',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.orangeAccent),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 18),
                  Container(
                    margin: const EdgeInsets.only(right: 32),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: CupertinoTextField.borderless(
                      style: Theme.of(context).textTheme.bodyText1,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.black12))),
                      suffix: const FaIcon(
                        FontAwesomeIcons.search,
                        size: 16,
                        color: Colors.orangeAccent,
                      ),
                      textAlign: TextAlign.right,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      placeholder: 'filter tags',
                      placeholderStyle: Theme.of(context).textTheme.bodyText2,
                      clearButtonMode: OverlayVisibilityMode.editing,
                      controller: controller,
                      onChanged: (value) => filterListPerTag(value),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: foundFilesWithTag.isNotEmpty
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              final audio = foundFilesWithTag[index];
                              return Dismissible(
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (direction) async {
                                  Platform.isIOS
                                      ? await iosModal(
                                          context,
                                          controller,
                                          directory,
                                          foundFilesWithTag,
                                          index,
                                          audio)
                                      : await androidModal(
                                          context,
                                          controller,
                                          directory,
                                          foundFilesWithTag,
                                          index,
                                          audio);

                                  refreshAudioFileList();
                                },
                                onDismissed: (direction) {
                                  AudioDatabase.instance
                                      .delete(foundFilesWithTag[index].id!);
                                  final targetFile = File(
                                      "${directory!.path}/${foundFilesWithTag[index].fileName}.aac");
                                  targetFile.deleteSync(recursive: true);
                                  foundFilesWithTag.removeAt(index);
                                  setState(() {});
                                },
                                key:
                                    Key(foundFilesWithTag[index].id.toString()),
                                background: stackBehindDismiss(),
                                child: InkWell(
                                  focusColor: Colors.lightBlueAccent,
                                  splashColor: Colors.lightBlueAccent,
                                  onTap: () async {
                                    await player.togglePlaying(
                                        whenFinished: () {
                                          setState(() {});
                                        },
                                        fileName: directory!.uri
                                                .toFilePath(windows: false) +
                                            foundFilesWithTag[index].fileName +
                                            '.aac');

                                    setState(() {});
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            player.fileBeingPlayed ==
                                                    directory!.uri.toFilePath(
                                                            windows: false) +
                                                        foundFilesWithTag[index]
                                                            .fileName +
                                                        '.aac'
                                                ? BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.1),
                                                    spreadRadius: 1,
                                                    blurRadius: 0,
                                                    offset: const Offset(0, 1))
                                                : const BoxShadow(
                                                    color: Colors.transparent)
                                          ],
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.grey
                                                      .withOpacity(0.15)))),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: tile(context, format, audio)),
                                ),
                              );
                            },
                            itemCount: foundFilesWithTag.length)
                        : Center(
                            child: Text(
                            'No files with this tag',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Colors.orangeAccent),
                          )),
                  ),
                ],
              );
  }
}

Widget tile(context, format, audio) {
  return MediaQuery.of(context).textScaleFactor > 1
      ? Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      left:
                          MediaQuery.of(context).textScaleFactor > 1 ? 20 : 30),
                  child: Text(
                    format.format(DateTime.fromMillisecondsSinceEpoch(
                        int.parse(audio.fileName.split('.aac').first))),
                    style: Theme.of(context).textTheme.subtitle1,
                    softWrap: true,
                  )),
              Container(
                margin: EdgeInsets.only(
                    right:
                        MediaQuery.of(context).textScaleFactor > 1 ? 20 : 30),
                child: Text(
                  '${audio.tag}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              )
            ],
          ),
        )
      : Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).textScaleFactor > 1 ? 20 : 30),
                child: Text(
                  format.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(audio.fileName.split('.aac').first))),
                  style: Theme.of(context).textTheme.subtitle1,
                  softWrap: true,
                )),
            Container(
              margin: EdgeInsets.only(
                  right: MediaQuery.of(context).textScaleFactor > 1 ? 20 : 30),
              child: Text(
                '${audio.tag}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            )
          ],
        );
}

Widget stackBehindDismiss() {
  return Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 20.0),
    color: Colors.red[400],
    child: const Icon(
      Icons.delete,
      color: Colors.white,
    ),
  );
}

Future<dynamic> iosModal(
    context, controller, directory, foundFilesWithTag, index, audio) async {
  return await showCupertinoModalPopup(
    barrierDismissible: false,
    context: context,
    builder: (context) => CupertinoTheme(
      data: CupertinoThemeData(
          brightness:
              ThemeProvider().isDarkMode ? Brightness.dark : Brightness.light),
      child: CupertinoAlertDialog(
        title: const Text(
          'Are you sure?',
          style: TextStyle(fontSize: 20),
        ),
        content:
            const Text('This can\'t be undone', style: TextStyle(fontSize: 16)),
        actions: [
          CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const FaIcon(FontAwesomeIcons.times)),
          CupertinoDialogAction(
            onPressed: () async {
              await AudioDatabase.instance.delete(foundFilesWithTag[index].id!);
              final targetFile = File(
                  "${directory!.path}/${foundFilesWithTag[index].fileName}.aac");
              targetFile.deleteSync(recursive: true);
              Navigator.of(context).pop();
            },
            child: const FaIcon(FontAwesomeIcons.check),
          ),
        ],
      ),
    ),
  );
}

Future<dynamic> androidModal(
    context, controller, directory, foundFilesWithTag, index, audio) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              ThemeProvider().isDarkMode ? Colors.grey[800] : Colors.white,
          title: const Text('Are you sure?',
              style: TextStyle(color: Colors.redAccent)),
          content: SingleChildScrollView(
              child: Text(
            'This can\'t be undone',
            style: TextStyle(
                color: ThemeProvider().isDarkMode
                    ? Colors.white
                    : Colors.grey[800]),
          )),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCEL')),
            TextButton(
                onPressed: () async {
                  await AudioDatabase.instance
                      .delete(foundFilesWithTag[index].id!);
                  final targetFile = File(
                      "${directory!.path}/${foundFilesWithTag[index].fileName}.aac");
                  targetFile.deleteSync(recursive: true);
                  Navigator.of(context).pop();
                },
                child: const Text('DELETE'))
          ],
        );
      });
}

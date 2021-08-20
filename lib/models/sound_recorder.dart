import 'dart:io';

import 'package:audio_journal/data/audio_file_db.dart';
import 'package:audio_journal/data/audio_file_model.dart';
import 'package:audio_journal/data/audio_model.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:permission_handler/permission_handler.dart';

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialised = false;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  Directory? _directory;
  String? _directoryPath;
  String? _fileName;
  AudioFileModel audioFileModel = AudioFileModel();

  Future<void> getDirectory() async {
    _directory = await getApplicationDocumentsDirectory();
    _directoryPath = _directory!.path;
  }

  String getFileName() {
    String? _date;
    _date = DateTime.now().millisecondsSinceEpoch.toString();
    return _fileName = _date.toString();
  }

  Future init() async {
    await getDirectory();
    _audioRecorder = FlutterSoundRecorder();
    // final status = await Permission.microphone.request();
    // if (status != PermissionStatus.granted) {
    // throw RecordingPermissionException('Microphone permission not granted');
    // }
    await _audioRecorder!.openAudioSession();
    _isRecorderInitialised = true;
  }

  void dispose() {
    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecorderInitialised = false;
  }

  Future record() async {
    getFileName();
    isRecording = true;
    if (!_isRecorderInitialised) return;
    await _audioRecorder!
        .startRecorder(toFile: '$_directoryPath/$_fileName' + '.aac');
  }

  Future updateDB(mood, tag) async {
    final db = await AudioDatabase.instance;
    db.create(AudioFile(
        id: int.parse(_fileName!), fileName: _fileName!, mood: mood, tag: tag));
    _fileName = null;
  }

  Future stop() async {
    if (!_isRecorderInitialised) return;
    isRecording = false;
    isRecordingCompleted = true;
    await _audioRecorder!.stopRecorder();
    // _fileName = null;
  }

  Future toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await record();
    } else {
      await stop();
    }
  }
}

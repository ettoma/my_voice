import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialised = false;
  bool get isRecording => _audioRecorder!.isRecording;
  Directory? _directory;
  String? _directoryPath;
  String? _fileName;

  Future getDirectory() async {
    _directory = await getApplicationDocumentsDirectory();
    _directoryPath = _directory!.path;
    return _directoryPath;
  }

  String getFileName() {
    // Consider adding more fields if you want
    String? _date; // to keep more than one file per day.
    _date = DateTime.now().day.toString() +
        DateTime.now().month.toString() +
        DateTime.now().year.toString();
    return _fileName = _date + '.aac';
  }

  Future init() async {
    getFileName();
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
    if (!_isRecorderInitialised) return;
    await _audioRecorder!.startRecorder(toFile: '$_directoryPath/$_fileName');
  }

  Future stop() async {
    if (!_isRecorderInitialised) return;
    await _audioRecorder!.stopRecorder();
  }

  Future toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await record();
    } else {
      await stop();
    }
  }
}

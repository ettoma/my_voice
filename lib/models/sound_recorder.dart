import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  final pathToSaveFile = 'audio_sample.aac';
  bool _isRecorderInitialised = false;
  bool get isRecording => _audioRecorder!.isRecording;

  Future init() async {
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
    await _audioRecorder!.startRecorder(toFile: pathToSaveFile);
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

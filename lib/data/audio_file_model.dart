import 'package:flutter/cupertino.dart';

class AudioFileModel extends ChangeNotifier {
  List<RecordedFile> fileList = [];

  void addFile(fileName, timeStamp, tag, mood) {
    fileList.add(RecordedFile(fileName, timeStamp, tag, mood));
  }
}

class RecordedFile {
  String fileName;
  int timeStamp;
  String tag;
  String mood;

  RecordedFile(this.fileName, this.timeStamp, this.tag, this.mood);
}

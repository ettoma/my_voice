import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioFileModel extends ChangeNotifier {
  List<RecordedFile> fileList = [];

  void addFile(fileName, tag, mood) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonFileList = [];
    fileList.add(RecordedFile(fileName, tag, mood));
    for (var element in fileList) {
      Map<String, dynamic> map = {
        'fileName': element.fileName,
        'tag': element.tag,
        'mood': element.mood
      };
      var rawData = jsonEncode(map);
      jsonFileList.add(rawData);
    }
    prefs.setStringList('fileList', jsonFileList);
  }

  void deleteFile(fileToDelete) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var fileListStorage = prefs.getStringList('fileList');
    fileListStorage!.remove(fileToDelete);
    prefs.setStringList('fileList', fileListStorage);
  }
}

class RecordedFile {
  String fileName;
  String tag;
  String mood;

  RecordedFile(this.fileName, this.tag, this.mood);

  factory RecordedFile.fromJson(Map<String, dynamic> json) {
    return RecordedFile(
      json['fileName'],
      json['tag'],
      json['mood'],
    );
  }
}

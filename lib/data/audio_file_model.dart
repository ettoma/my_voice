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
    // print(jsonFileList.toString());
    var decodedList = jsonDecode(prefs.getStringList('fileList').toString());
    print(decodedList);
  }
}

class RecordedFile {
  String fileName;
  String tag;
  String mood;

  RecordedFile(this.fileName, this.tag, this.mood);
}

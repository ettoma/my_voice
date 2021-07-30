import 'dart:collection';

import 'package:flutter/material.dart';

class AudioFileModel extends ChangeNotifier {
  final List<String> _list = [];

  UnmodifiableListView<String> get items => UnmodifiableListView(_list);

  int get totalPrice => _list.length;

  void add(String item) {
    _list.add(item);
    notifyListeners();
  }

  void removeAll() {
    _list.clear();
    notifyListeners();
  }
}

class AudioFiles {
  List<String> fileList = [];

  void addFile(fileName) {
    fileList.add(fileName);
    print(fileList.toString());
  }
}

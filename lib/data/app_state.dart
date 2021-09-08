import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  var userName;

  void setName(String enteredUsername) {
    userName = enteredUsername;
    notifyListeners();
  }
}

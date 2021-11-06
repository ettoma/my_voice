import 'package:audio_journal/utils/shared_prefs.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget appBar(context) {
  return AppBar(
    automaticallyImplyLeading: true,
    iconTheme: const IconThemeData(color: Color.fromRGBO(0, 0, 0, 0.5)),
    backgroundColor: Theme.of(context).backgroundColor,
    elevation: 0,
    centerTitle: true,
    title: Text(
      sharedPrefs.username.isNotEmpty
          ? '${sharedPrefs.username}\'s voice'
          : 'my voice',
      style: const TextStyle(color: Color.fromRGBO(211, 210, 207, 0.5)),
    ),
  );
}

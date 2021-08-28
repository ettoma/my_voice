import 'package:flutter/material.dart';

PreferredSizeWidget appBar(context) {
  return AppBar(
    automaticallyImplyLeading: true,
    iconTheme: const IconThemeData(color: Color.fromRGBO(0, 0, 0, 0.5)),
    backgroundColor: Theme.of(context).backgroundColor,
    elevation: 0,
    brightness: Brightness.light,
    title: Text(
      'my voice',
      style: TextStyle(color: Color.fromRGBO(211, 210, 207, 0.5)),
    ),
  );
}

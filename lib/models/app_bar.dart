import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

PreferredSizeWidget appBar() {
  return AppBar(
    automaticallyImplyLeading: true,
    iconTheme: const IconThemeData(color: Color.fromRGBO(0, 0, 0, 0.5)),
    backgroundColor: const Color.fromRGBO(255, 255, 255, 0),
    elevation: 0,
    brightness: Brightness.light,
  );
}

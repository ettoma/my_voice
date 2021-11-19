import 'package:audio_journal/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

Color darkText = Colors.white70;
Color lightText = const Color.fromRGBO(46, 48, 64, 1);
var brightness = SchedulerBinding.instance!.window.platformBrightness;

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = sharedPrefs.darkThemePreference == ''
      ? ThemeMode.system
      : sharedPrefs.darkThemePreference == 'light'
          ? ThemeMode.light
          : ThemeMode.dark;

  bool get isDarkMode =>
      themeMode == ThemeMode.dark || brightness == Brightness.dark;

  void toggleMode(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class AppTheme {
  static ThemeMode themeMode() {
    ThemeMode themeModePref;
    if (sharedPrefs.darkThemePreference == 'dark') {
      themeModePref = ThemeMode.dark;
    } else if (sharedPrefs.darkThemePreference == 'light') {
      themeModePref = ThemeMode.light;
    } else {
      themeModePref = ThemeMode.system;
    }
    return themeModePref;
  }

  static final darkTheme = ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        iconTheme: IconThemeData(color: darkText.withOpacity(0.5)),
      ),
      canvasColor: Colors.grey[900],
      textTheme: GoogleFonts.montserratTextTheme(
        TextTheme(
            headline1: TextStyle(
                fontSize: 32, color: darkText, fontWeight: FontWeight.w500),
            headline2: TextStyle(
              fontSize: 24,
              color: darkText,
            ),
            subtitle1: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: darkText,
            ),
            bodyText1: TextStyle(
              fontSize: 18,
              color: darkText,
            ),
            bodyText2:
                TextStyle(fontSize: 18, color: darkText.withOpacity(0.2))),
      ));

  static final lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: lightText.withOpacity(0.5)),
    ),
    canvasColor: Colors.white,
    textTheme: GoogleFonts.montserratTextTheme(
      TextTheme(
          headline1: TextStyle(
              fontSize: 32, color: lightText, fontWeight: FontWeight.w500),
          headline2: TextStyle(fontSize: 24, color: lightText),
          subtitle1: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: lightText,
          ),
          bodyText1: TextStyle(
            fontSize: 18,
            color: lightText,
          ),
          bodyText2:
              TextStyle(fontSize: 18, color: lightText.withOpacity(0.2))),
    ),
  );
}

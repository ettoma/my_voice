import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  init() async {
    _sharedPrefs ??= _sharedPrefs = await SharedPreferences.getInstance();
  }

  clear() {
    _sharedPrefs!.clear();
  }

  String get username => _sharedPrefs!.getString(keyName) ?? '';

  set username(String value) {
    _sharedPrefs!.setString(keyName, value);
  }

  int get animationPref => _sharedPrefs!.getInt(animationPrefInt) ?? 0;

  set animationPref(int value) {
    _sharedPrefs!.setInt(animationPrefInt, value);
  }

  bool get notificationPref =>
      _sharedPrefs!.getBool(notificationPrefBool) ?? true;

  set notificationPref(bool value) {
    _sharedPrefs!.setBool(notificationPrefBool, value);
  }

  String get darkThemePreference =>
      _sharedPrefs!.getString(darkThemePref) ?? '';

  set darkThemePreference(String value) {
    _sharedPrefs!.setString(darkThemePref, value);
  }
}

final sharedPrefs = SharedPrefs();
const String keyName = 'name';
const String animationPrefInt = 'animation';
const String notificationPrefBool = 'notification';
const String darkThemePref = 'darkTheme';

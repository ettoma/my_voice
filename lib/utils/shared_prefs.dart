import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  init() async {
    _sharedPrefs ??= _sharedPrefs = await SharedPreferences.getInstance();
  }

  String get username => _sharedPrefs!.getString(keyName) ?? '';

  set username(String value) {
    _sharedPrefs!.setString(keyName, value);
  }

  clear() {
    _sharedPrefs!.clear();
  }
}

final sharedPrefs = SharedPrefs();
const String keyName = 'name';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;
  static const KEY_USER = "user";
  static const KEY_TOKEN = "token";

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  String get user => _sharedPrefs?.getString(KEY_USER) ?? "";
  String get token => _sharedPrefs?.getString(KEY_USER) ?? "";

  set user(String value) {
    _sharedPrefs?.setString(KEY_USER, value);
  }

  set token(String value) {
    _sharedPrefs?.setString(KEY_TOKEN, value);
  }
}

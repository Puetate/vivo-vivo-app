import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;
  // ignore: constant_identifier_names
  static const KEY_USER = "user";
  static const KEY_TOKEN = "token";
  static const KEY_STATE = "state";
  static const KEY_ID_ALARM = "idAlarm";
  static const KEY_FAMILY_GROUP_IDS = "familyGroupIds";

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  String get user => _sharedPrefs?.getString(KEY_USER) ?? "";
  String get token => _sharedPrefs?.getString(KEY_TOKEN) ?? "";
  String get state => _sharedPrefs?.getString(KEY_STATE) ?? "";
  int get idAlarm => _sharedPrefs?.getInt(KEY_ID_ALARM) ?? -0;
  String get familyGroupIds =>
      _sharedPrefs?.getString(KEY_FAMILY_GROUP_IDS) ?? "";

  set user(String value) {
    _sharedPrefs?.setString(KEY_USER, value);
  }

  set token(String value) {
    _sharedPrefs?.setString(KEY_TOKEN, value);
  }

  set state(String value) {
    _sharedPrefs?.setString(KEY_STATE, value);
  }

  set idAlarm(int value) {
    _sharedPrefs?.setInt(KEY_ID_ALARM, value);
  }

  set familyGroupIds(String value) {
    _sharedPrefs?.setString(KEY_FAMILY_GROUP_IDS, value);
  }

  void logout() {
    _sharedPrefs?.remove(KEY_USER);
    _sharedPrefs?.remove(KEY_TOKEN);
  }

  void removeAlarmInfo() {
    _sharedPrefs?.remove(KEY_ID_ALARM);
    _sharedPrefs?.remove(KEY_FAMILY_GROUP_IDS);
  }
}

final sharedPrefs = SharedPrefs();

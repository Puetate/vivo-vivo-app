import 'package:flutter/material.dart';
import 'package:vivo_vivo_app/src/domain/models/user.dart';
import 'package:vivo_vivo_app/src/domain/models/user_pref_provider.dart';

class UserProvider extends ChangeNotifier {
  UserPrefProvider? userData;

  UserPrefProvider? get getUserPrefProvider => userData;

  Future<UserPrefProvider?> setUser(User user, String token) async {
    if (userData != null) {
      return userData;
    }
    userData = UserPrefProvider(user: user, token: token);
    notifyListeners();
    return userData;
  }

  bool resetUser() {
    if (userData != null) {
      userData = null;
      return true;
    } else {
      return false;
    }
  }
}

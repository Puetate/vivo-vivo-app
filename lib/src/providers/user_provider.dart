import 'package:flutter/material.dart';
import 'package:vivo_vivo_app/src/domain/models/user_pref_provider.dart';

class UserProvider with ChangeNotifier {
  UserPrefProvider? userData;

  UserPrefProvider? get getUserPrefProvider => userData;

  bool getUser(UserAuth user, String token) {
    if (userData != null) return true;
    userData = UserPrefProvider(user: user, token: token);
    // notifyListeners();
    return true;
  }

  bool resetUser() {
    if (userData != null) {
      userData = null;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}

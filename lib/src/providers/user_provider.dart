import 'package:flutter/material.dart';
import 'package:vivo_vivo_app/src/domain/models/user.dart';

class UserProvider extends ChangeNotifier {
   Map<String, dynamic> userData = {};

  Future<Map<String, dynamic>> getUser(credentials,
      [User? user, String? token]) async {
    // ignore: unnecessary_null_comparison
    if (userData != null) {
      return userData;
    }

    if (user != null && token != null) {
      userData = {
        "user": user,
        "token": token,
      };
    } else {
      /* var service = UserServices();
      Map userMap = await service.getUser(credentials);
      if (userMap == null) return null;
      userData = {
        "user": userMap["user"],
        "token": userMap["token"],
      }; */
    }

    notifyListeners();
    return userData;
  }

  bool resetUser() {
    // ignore: unnecessary_null_comparison
    if (userData != null) {
      userData = {};
      return true;
    } else {
      return false;
    }
  }
}

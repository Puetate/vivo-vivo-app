import 'dart:convert';

import 'package:vivo_vivo_app/src/domain/models/user_pref_provider.dart';

UserAlert userAlertFromJson(String str) => UserAlert.fromJson(json.decode(str));

/// The UserAlert class has a user property of type User
class UserAlert {
  /// A constructor.
  UserAlert({
    required this.user,
    required this.state,
  });

  String state;
  UserAuth user;
  /// It takes a JSON string, converts it to a Map, then uses the Map to create a UserAlert object
  /// 
  /// Args:
  ///   json (Map<String, dynamic>): The JSON object that you want to convert to a Dart object.
  factory UserAlert.fromJson(Map<String, dynamic> json) => UserAlert(
        state: json["state"],
        user: userAuthFromJson(jsonEncode(json["user"])),
      );
}

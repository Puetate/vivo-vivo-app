// To parse this JSON data, do
//
//     final userAlert = userAlertFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

UserAlert userAlertFromJson(String str) => UserAlert.fromJson(json.decode(str));

String userAlertToJson(UserAlert data) => json.encode(data.toJson());
String HOST = dotenv.env['HOST']!;

class UserAlert {
  int userID;
  String avatar;
  String names;
  String status;

  UserAlert({
    required this.userID,
    required this.avatar,
    required this.names,
    required this.status,
  });

  factory UserAlert.fromJson(Map<String, dynamic> json) => UserAlert(
        userID: json["userID"],
        avatar: "$HOST/${json["avatar"]}",
        names: json["names"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "userID": userID,
        "avatar": avatar,
        "names": names,
        "status": status,
      };
}

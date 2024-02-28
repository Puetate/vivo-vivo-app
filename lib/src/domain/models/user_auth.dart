import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vivo_vivo_app/src/domain/models/role.dart';

String userAuthToJson(UserAuth data) => json.encode(data.toJson());
UserAuth userAuthFromJson(String str) => UserAuth.fromJson(json.decode(str));
UserAuth userAuthFromJsonPreferences(String str) => UserAuth.fromJsonPreferences(json.decode(str));

String HOST = dotenv.env['HOST']!;


class UserAuth {
  int userID;
  int personID;
  String names;
  String email;
  String phone;
  String? idOneSignal;
  String avatar;
  List<Role> roles;

  UserAuth({
    required this.userID,
    required this.personID,
    required this.names,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.roles,
  });

  factory UserAuth.fromJson(Map<String, dynamic> json) => UserAuth(
        userID: json["userID"],
        personID: json["personID"],
        names: json["names"],
        email: json["email"],
        phone: json["phone"],
        avatar: "$HOST/${json["avatar"]}",
        roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
      );

  factory UserAuth.fromJsonPreferences(Map<String, dynamic> json) => UserAuth(
        userID: json["userID"],
        personID: json["personID"],
        names: json["names"],
        email: json["email"],
        phone: json["phone"],
        avatar: json["avatar"],
        roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userID": userID,
        "personID": personID,
        "names": names,
        "email": email,
        "phone": phone,
        "avatar": avatar,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
      };
}
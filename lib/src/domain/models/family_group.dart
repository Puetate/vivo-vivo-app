// To parse this JSON data, do
//
//     final familyGroup = familyGroupFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

FamilyGroupResponse familyGroupFromJson(String str) =>
    FamilyGroupResponse.fromJson(json.decode(str));

String familyGroupToJson(FamilyGroupResponse data) =>
    json.encode(data.toJson());
String HOST = dotenv.env['HOST']!;

class FamilyGroupResponse {
  int? userID;
  String names;
  String dni;
  String avatar;
  String phone;

  FamilyGroupResponse({
    this.userID,
    required this.names,
    required this.dni,
    required this.avatar,
    required this.phone,
  });

  factory FamilyGroupResponse.fromJson(Map<String, dynamic> json) =>
      FamilyGroupResponse(
        userID: json["userID"],
        names: json["names"],
        dni: json["dni"],
        avatar: "$HOST${json["avatar"]}",
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "names": names,
        "dni": dni,
        "avatar": avatar,
        "phone": phone,
      };
}

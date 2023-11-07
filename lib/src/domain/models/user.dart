// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:vivo_vivo_app/src/domain/models/person.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? id;
  String username;
  String email;
  String password;
  Person? person;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.person,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        person: Person.fromJson(json["person"]),
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
        "password": password,
        "person": person!.toJson(),
        "status": status,
        "createdAt": (createdAt != null) ? createdAt!.toIso8601String() : null,
        "updatedAt": (updatedAt != null) ? updatedAt!.toIso8601String() : null,
      };
}

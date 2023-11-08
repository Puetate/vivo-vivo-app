import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

UserPrefProvider userPrefProviderFromJson(String str) =>
    UserPrefProvider.fromJson(json.decode(str));

String userPrefProviderToJson(UserPrefProvider data) =>
    json.encode(data.toJson());

String userAuthToJson(UserAuth data) => json.encode(data.toJson());
UserAuth userAuthFromJson(String str) =>
    UserAuth.fromJson(json.decode(str));

    String HOST = dotenv.env['HOST']!;

class UserPrefProvider {
  UserAuth user;
  String token;

  UserPrefProvider({
    required this.user,
    required this.token,
  });

  UserAuth get getUser => user;
  String get getToken => token;

  set setUser(UserAuth user) => this.user = user;
  set setToken(String token) => this.token = token;

  factory UserPrefProvider.fromJson(Map<String, dynamic> json) =>
      UserPrefProvider(
        user: UserAuth.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token,
      };
}

class UserAuth {
  String idUser;
  String idPerson;
  String username;
  String email;
  String phone;
  String avatar;
  String? idOneSignal;
  List<Role> roles;

  UserAuth({
    required this.idUser,
    required this.idPerson,
    required this.username,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.roles,
  });

  factory UserAuth.fromJson(Map<String, dynamic> json) => UserAuth(
        idUser: json["idUser"],
        idPerson: json["idPerson"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        avatar:"$HOST${json["avatar"]}",
        roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "idUser": idUser,
        "idPerson": idPerson,
        "username": username,
        "email": email,
        "phone": phone,
        "avatar": avatar,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
      };
}

class Role {
  String id;
  String rolName;

  Role({
    required this.id,
    required this.rolName,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["_id"],
        rolName: json["rolName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "rolName": rolName,
      };
}

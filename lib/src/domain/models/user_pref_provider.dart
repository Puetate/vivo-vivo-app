import 'dart:convert';

import 'package:vivo_vivo_app/src/domain/models/user_auth.dart';

UserPrefProvider userPrefProviderFromJson(String str) =>
    UserPrefProvider.fromJson(json.decode(str));

String userPrefProviderToJson(UserPrefProvider data) =>
    json.encode(data.toJson());

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

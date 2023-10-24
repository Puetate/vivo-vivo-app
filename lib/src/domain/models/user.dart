import 'dart:convert';

import 'package:vivo_vivo_app/src/domain/models/person.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    String id;
    String userName;
    String email;
    String password;
    String userType;
    Person person;
    String idOneSignal;

    User({
        required this.id,
        required this.userName,
        required this.email,
        required this.password,
        required this.userType,
        required this.person,
        required this.idOneSignal,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        userName: json["userName"],
        email: json["email"],
        password: json["password"],
        userType: json["userType"],
        person: Person.fromJson(json["person"]),
        idOneSignal: json["idOneSignal"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userName": userName,
        "email": email,
        "password": password,
        "userType": userType,
        "person": person.toJson(),
        "idOneSignal": idOneSignal,
    };
}
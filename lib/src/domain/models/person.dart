import 'package:vivo_vivo_app/src/domain/models/person_disability.dart';
import 'package:vivo_vivo_app/src/domain/models/person_info.dart';

class Person {
  String? id;
  String firstName;
  String middleName;
  String lastNames;
  String dni;
  dynamic avatar;
  PersonInfo? personInfo;
  PersonDisability? personDisability;
  DateTime? updatedAt;
  DateTime? createdAt;

  Person({
    this.id,
    required this.firstName,
    required this.middleName,
    required this.lastNames,
    required this.dni,
    required this.avatar,
    this.personDisability,
    this.personInfo,
    this.createdAt,
    this.updatedAt,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json["_id"],
        firstName: json["firstName"],
        middleName: json["middleName"],
        lastNames: json["lastNames"],
        dni: json["dni"],
        avatar: json["avatar"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        // "_id": id,
        "firstName": firstName,
        "middleName": middleName,
        "lastNames": lastNames,
        "dni": dni,
        "avatar": avatar,
        /* "createdAt": (createdAt != null) ? createdAt!.toIso8601String() : null,
        "updatedAt": (updatedAt != null) ? updatedAt!.toIso8601String() : null, */
      };
}

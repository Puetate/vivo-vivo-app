// To parse this JSON data, do
//
//     final person = personFromJson(jsonString);

import 'dart:convert';

Person personFromJson(String str) => Person.fromJson(json.decode(str));

String personToJson(Person data) => json.encode(data.toJson());

class Person {
    String id;
    String firstName;
    String middleName;
    String lastName;
    String idCard;
    String phone;
    DateTime birthDate;
    String address;
    String gender;
    String urlImage;
    String ethnic;
    bool disability;
    String maritalStatus;

    Person({
        required this.id,
        required this.firstName,
        required this.middleName,
        required this.lastName,
        required this.idCard,
        required this.phone,
        required this.birthDate,
        required this.address,
        required this.gender,
        required this.urlImage,
        required this.ethnic,
        required this.disability,
        required this.maritalStatus,
    });

    factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json["_id"],
        firstName: json["firstName"],
        middleName: json["middleName"],
        lastName: json["lastName"],
        idCard: json["idCard"],
        phone: json["phone"],
        birthDate: DateTime.parse(json["birthDate"]),
        address: json["address"],
        gender: json["gender"],
        urlImage: json["urlImage"],
        ethnic: json["ethnic"],
        disability: json["disability"],
        maritalStatus: json["maritalStatus"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "idCard": idCard,
        "phone": phone,
        "birthDate": birthDate.toIso8601String(),
        "address": address,
        "gender": gender,
        "urlImage": urlImage,
        "ethnic": ethnic,
        "disability": disability,
        "maritalStatus": maritalStatus,
    };
}

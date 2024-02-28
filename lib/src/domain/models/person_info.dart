import 'dart:convert';

PersonInfo personInfoFromJson(String str) =>
    PersonInfo.fromJson(json.decode(str));

String personInfoToJson(PersonInfo data) => json.encode(data.toJson());

class PersonInfo {
  String phone;
  DateTime birthDate;
  String address;
  int genderID;
  int ethnicID;
  int maritalStatusID;

  PersonInfo({
    required this.phone,
    required this.birthDate,
    required this.address,
    required this.genderID,
    required this.ethnicID,
    required this.maritalStatusID,
  });

  factory PersonInfo.fromJson(Map<String, dynamic> json) => PersonInfo(
        phone: json["phone"],
        birthDate: DateTime.parse(json["birthDate"]),
        address: json["address"],
        genderID: json["gender"],
        ethnicID: json["ethnic"],
        maritalStatusID: json["maritalStatus"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "birthDate": birthDate.toIso8601String(),
        "address": address,
        "genderID": genderID,
        "ethnicID": ethnicID,
        "maritalStatusID": maritalStatusID,
      };
}

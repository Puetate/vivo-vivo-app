import 'dart:convert';

PersonInfo personInfoFromJson(String str) => PersonInfo.fromJson(json.decode(str));

String personInfoToJson(PersonInfo data) => json.encode(data.toJson());

class PersonInfo {
    String phone;
    DateTime birthDate;
    String address;
    String gender;
    String ethnic;
    String maritalStatus;

    PersonInfo({
        required this.phone,
        required this.birthDate,
        required this.address,
        required this.gender,
        required this.ethnic,
        required this.maritalStatus,
    });

    factory PersonInfo.fromJson(Map<String, dynamic> json) => PersonInfo(
        phone: json["phone"],
        birthDate: DateTime.parse(json["birthDate"]),
        address: json["address"],
        gender: json["gender"],
        ethnic: json["ethnic"],
        maritalStatus: json["maritalStatus"],
    );

    Map<String, dynamic> toJson() => {
        "phone": phone,
        "birthDate": birthDate.toIso8601String(),
        "address": address,
        "gender": gender,
        "ethnic": ethnic,
        "maritalStatus": maritalStatus,
    };
}

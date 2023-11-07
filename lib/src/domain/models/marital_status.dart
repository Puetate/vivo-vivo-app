// To parse this JSON data, do
//
//     final maritalStatus = maritalStatusFromJson(jsonString);

import 'dart:convert';

MaritalStatus maritalStatusFromJson(String str) => MaritalStatus.fromJson(json.decode(str));

String maritalStatusToJson(MaritalStatus data) => json.encode(data.toJson());

class MaritalStatus {
    String id;
    int name;

    MaritalStatus({
        required this.id,
        required this.name,
    });

    factory MaritalStatus.fromJson(Map<String, dynamic> json) => MaritalStatus(
        id: json["_id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
    };
}

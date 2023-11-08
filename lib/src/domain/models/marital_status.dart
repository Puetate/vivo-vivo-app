// To parse this JSON data, do
//
//     final maritalStatus = maritalStatusFromJson(jsonString);

import 'dart:convert';

DropDownItem maritalStatusFromJson(String str) =>
    DropDownItem.fromJson(json.decode(str));

String maritalStatusToJson(DropDownItem data) => json.encode(data.toJson());

class DropDownItem {
  String id;
  String name;

  DropDownItem({
    required this.id,
    required this.name,
  });

  factory DropDownItem.fromJson(Map<String, dynamic> json) => DropDownItem(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

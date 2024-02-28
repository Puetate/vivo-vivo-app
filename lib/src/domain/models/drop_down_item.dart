// To parse this JSON data, do
//
//     final dropDownItem = dropDownItemFromJson(jsonString);

import 'dart:convert';

DropDownItem dropDownItemFromJson(String str) => DropDownItem.fromJson(json.decode(str));

String dropDownItemToJson(DropDownItem data) => json.encode(data.toJson());

class DropDownItem {
    int id;
    String name;

    DropDownItem({
        required this.id,
        required this.name,
    });

    factory DropDownItem.fromJson(Map<String, dynamic> json) => DropDownItem(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

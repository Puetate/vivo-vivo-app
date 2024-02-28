import 'dart:convert';

Role roleFromJson(String str) => Role.fromJson(json.decode(str));

String roleToJson(Role data) => json.encode(data.toJson());

class Role {
  int roleId;
  String roleName;

  Role({
    required this.roleId,
    required this.roleName,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        roleId: json["roleID"],
        roleName: json["roleName"],
      );

  Map<String, dynamic> toJson() => {
        "roleID": roleId,
        "roleName": roleName,
      };
}

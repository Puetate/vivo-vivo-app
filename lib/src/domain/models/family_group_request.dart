import 'dart:convert';

FamilyGroupRequest familyGroupRequestFromJson(String str) => FamilyGroupRequest.fromJson(json.decode(str));

String familyGroupRequestToJson(FamilyGroupRequest data) => json.encode(data.toJson());

class FamilyGroupRequest {
    String user;
    String userFamilyMember;

    FamilyGroupRequest({
        required this.user,
        required this.userFamilyMember,
    });

    factory FamilyGroupRequest.fromJson(Map<String, dynamic> json) => FamilyGroupRequest(
        user: json["user"],
        userFamilyMember: json["userFamilyMember"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "userFamilyMember": userFamilyMember,
    };
}

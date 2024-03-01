import 'dart:convert';

FamilyGroupRequest familyGroupRequestFromJson(String str) =>
    FamilyGroupRequest.fromJson(json.decode(str));

String familyGroupRequestToJson(FamilyGroupRequest data) =>
    json.encode(data.toJson());

class FamilyGroupRequest {
  int userID;
  int userFamilyMemberID;

  FamilyGroupRequest({
    required this.userID,
    required this.userFamilyMemberID,
  });

  factory FamilyGroupRequest.fromJson(Map<String, dynamic> json) =>
      FamilyGroupRequest(
        userID: json["user"],
        userFamilyMemberID: json["userFamilyMember"],
      );

  Map<String, dynamic> toJson() => {
        "userID": userID,
        "userFamilyMemberID": userFamilyMemberID,
      };
}

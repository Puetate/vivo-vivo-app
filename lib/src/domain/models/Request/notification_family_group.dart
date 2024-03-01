import 'dart:convert';

NotificationFamilyGroup notificationFamilyGroupFromJson(String str) => NotificationFamilyGroup.fromJson(json.decode(str));

String notificationFamilyGroupToJson(NotificationFamilyGroup data) => json.encode(data.toJson());

class NotificationFamilyGroup {
    int userID;
    String names;

    NotificationFamilyGroup({
        required this.userID,
        required this.names,
    });

    factory NotificationFamilyGroup.fromJson(Map<String, dynamic> json) => NotificationFamilyGroup(
        userID: json["userID"],
        names: json["names"],
    );

    Map<String, dynamic> toJson() => {
        "userID": userID,
        "names": names,
    };
}

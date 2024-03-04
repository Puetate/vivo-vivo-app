// To parse this JSON data, do
//
//     final sendAlarmData = sendAlarmDataFromJson(jsonString);

import 'dart:convert';

SendAlarmData sendAlarmDataFromJson(String str) => SendAlarmData.fromJson(json.decode(str));

String sendAlarmDataToJson(SendAlarmData data) => json.encode(data.toJson());

class SendAlarmData {
    Position position;
    List<int> familyMemberUserIDs;
    int userID;

    SendAlarmData({
        required this.position,
        required this.familyMemberUserIDs,
        required this.userID,
    });

    factory SendAlarmData.fromJson(Map<String, dynamic> json) => SendAlarmData(
        position: Position.fromJson(json["position"]),
        familyMemberUserIDs: List<int>.from(json["familyMemberUserIDs"].map((x) => x)),
        userID: json["userID"],
    );

    Map<String, dynamic> toJson() => {
        "position": position.toJson(),
        "familyMemberUserIDs": List<dynamic>.from(familyMemberUserIDs.map((x) => x)),
        "userID": userID,
    };
}

class Position {
    double lat;
    double lng;

    Position({
        required this.lat,
        required this.lng,
    });

    factory Position.fromJson(Map<String, dynamic> json) => Position(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
    };
}

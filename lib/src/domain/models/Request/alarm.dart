// To parse this JSON data, do
//
//     final alarmRequest = alarmRequestFromJson(jsonString);

import 'dart:convert';

AlarmRequest alarmRequestFromJson(String str) =>
    AlarmRequest.fromJson(json.decode(str));

String alarmRequestToJson(AlarmRequest data) => json.encode(data.toJson());

Alarm alarmFromJson(String str) => Alarm.fromJson(json.decode(str));

class AlarmRequest {
  Alarm alarm;
  AlarmDetail alarmDetail;

  AlarmRequest({
    required this.alarm,
    required this.alarmDetail,
  });

  factory AlarmRequest.fromJson(Map<String, dynamic> json) => AlarmRequest(
        alarm: Alarm.fromJson(json["alarm"]),
        alarmDetail: AlarmDetail.fromJson(json["alarmDetail"]),
      );

  Map<String, dynamic> toJson() => {
        "alarm": alarm.toJson(),
        "alarmDetail": alarmDetail.toJson(),
      };
}

class Alarm {
  int? alarmID;
  int? alarmTypeID;
  int userID;
  String? alarmType;

  Alarm({required this.userID, this.alarmType, this.alarmID, this.alarmTypeID});

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
        alarmID: json["alarmID"],
        alarmTypeID: json["alarmTypeID"],
        userID: json["userID"],
        alarmType: json["alarmType"],
      );

  Map<String, dynamic> toJson() => {
        "userID": userID,
        "alarmType": alarmType,
      };
}

class AlarmDetail {
  int? alarmID;
  String alarmStatus;
  String alarmType;
  double latitude;
  double longitude;
  int? userID;

  AlarmDetail(
      {this.alarmID,
      required this.alarmStatus,
      required this.alarmType,
      required this.latitude,
      required this.longitude,
      this.userID});

  factory AlarmDetail.fromJson(Map<String, dynamic> json) => AlarmDetail(
        alarmID: json["alarm"],
        alarmStatus: json["alarmStatus"],
        alarmType: json["alarmType"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "alarmID": alarmID,
        "alarmStatus": alarmStatus,
        "alarmType": alarmType,
        "latitude": latitude,
        "longitude": longitude,
        "userID": userID
      };
}

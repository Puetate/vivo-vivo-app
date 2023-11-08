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
  String? id;
  String user;
  String alarmType;

  Alarm({required this.user, required this.alarmType, this.id});

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
        id: json["_id"],
        user: json["user"],
        alarmType: json["alarmType"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "alarmType": alarmType,
      };
}

class AlarmDetail {
  String? alarm;
  String alarmStatus;
  DateTime date;
  double latitude;
  double longitude;

  AlarmDetail({
    this.alarm,
    required this.alarmStatus,
    required this.date,
    required this.latitude,
    required this.longitude,
  });

  factory AlarmDetail.fromJson(Map<String, dynamic> json) => AlarmDetail(
        alarm: json["alarm"],
        alarmStatus: json["alarmStatus"],
        date: DateTime.parse(json["date"]),
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "alarm": alarm,
        "alarmStatus": alarmStatus,
        "date": date.toIso8601String(),
        "latitude": latitude,
        "longitude": longitude,
      };
}

// To parse this JSON data, do
//
//     final incidentType = incidentTypeFromJson(jsonString);

import 'dart:convert';

IncidentType incidentTypeFromJson(String str) => IncidentType.fromJson(json.decode(str));

String incidentTypeToJson(IncidentType data) => json.encode(data.toJson());

class IncidentType {
    int incidentTypeId;
    String incidentTypeName;

    IncidentType({
        required this.incidentTypeId,
        required this.incidentTypeName,
    });

    factory IncidentType.fromJson(Map<String, dynamic> json) => IncidentType(
        incidentTypeId: json["incidentTypeID"],
        incidentTypeName: json["incidentTypeName"],
    );

    Map<String, dynamic> toJson() => {
        "incidentTypeID": incidentTypeId,
        "incidentTypeName": incidentTypeName,
    };
}

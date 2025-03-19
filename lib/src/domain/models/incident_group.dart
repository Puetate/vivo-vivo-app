import 'dart:convert';

import 'package:vivo_vivo_app/src/domain/models/incident_type.dart';

List<IncidentGroup> incidentGroupFromJson(String str) => List<IncidentGroup>.from(json.decode(str).map((x) => IncidentGroup.fromJson(x)));

String incidentGroupToJson(List<IncidentGroup> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IncidentGroup {
    int incidentTypeHierarchyID;
    String incidentTypeHierarchyName;
    List<IncidentType> incidentTypes;

    IncidentGroup({
        required this.incidentTypeHierarchyID,
        required this.incidentTypeHierarchyName,
        required this.incidentTypes,
    });

    factory IncidentGroup.fromJson(Map<String, dynamic> json) => IncidentGroup(
        incidentTypeHierarchyID: json["incidentTypeHierarchyID"],
        incidentTypeHierarchyName: json["incidentTypeHierarchyName"],
        incidentTypes: List<IncidentType>.from(json["incidentTypes"].map((x) => IncidentType.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "incidentTypeHierarchyID": incidentTypeHierarchyID,
        "incidentTypeHierarchyName": incidentTypeHierarchyName,
        "incidentTypes": List<dynamic>.from(incidentTypes.map((x) => x.toJson())),
    };
}
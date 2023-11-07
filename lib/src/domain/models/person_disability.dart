import 'dart:convert';

PersonDisability personDisabilityFromJson(String str) => PersonDisability.fromJson(json.decode(str));

String personDisabilityToJson(PersonDisability data) => json.encode(data.toJson());

class PersonDisability {
    String disability;
    int percentage;

    PersonDisability({
        required this.disability,
        required this.percentage,
    });

    factory PersonDisability.fromJson(Map<String, dynamic> json) => PersonDisability(
        disability: json["disability"],
        percentage: json["percentage"],
    );

    Map<String, dynamic> toJson() => {
        "disability": disability,
        "percentage": percentage,
    };
}

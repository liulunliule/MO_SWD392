// To parse this JSON data, do
//
//     final achievement = achievementFromJson(jsonString);

import 'dart:convert';

Achievement achievementFromJson(String str) =>
    Achievement.fromJson(json.decode(str));

String achievementToJson(Achievement data) => json.encode(data.toJson());

class Achievement {
  int? achievementId;
  String? achievementName;
  String? achievementLink;
  String? achievementDescription;
  DateTime? createdAt;

  Achievement({
    this.achievementId,
    this.achievementName,
    this.achievementLink,
    this.achievementDescription,
    this.createdAt,
  });

  Achievement copyWith({
    int? achievementId,
    String? achievementName,
    String? achievementLink,
    String? achievementDescription,
    DateTime? createdAt,
  }) =>
      Achievement(
        achievementId: achievementId ?? this.achievementId,
        achievementName: achievementName ?? this.achievementName,
        achievementLink: achievementLink ?? this.achievementLink,
        achievementDescription:
            achievementDescription ?? this.achievementDescription,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
      achievementId: json["achievementId"].toInt(),
        achievementName: json["achievementName"],
        achievementLink: json["achievementLink"],
        achievementDescription: json["achievementDescription"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
    "achievementId":achievementId,
        "achievementName": achievementName,
        "achievementLink": achievementLink,
        "achievementDescription": achievementDescription,
        "created_at": createdAt?.toIso8601String(),
      };
}

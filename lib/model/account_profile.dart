// To parse this JSON data, do
//
//     final accountProfile = accountProfileFromJson(jsonString);

import 'dart:convert';

AccountProfile accountProfileFromJson(String str) => AccountProfile.fromJson(json.decode(str));

String accountProfileToJson(AccountProfile data) => json.encode(data.toJson());

class AccountProfile {
    int? id;
    String? name;
    String? email;
    String? role;
    DateTime? dayOfBirth;
    String? gender;
    String? phone;
    String? avatar;
    double? walletId;
    double? walletPoint;
    List<String>? specializations;
    String? facebookLink;
    String? linkedinLink;
    String? twitterLink;
    String? youtubeLink;

    AccountProfile({
        this.id,
        this.name,
        this.email,
        this.role,
        this.dayOfBirth,
        this.gender,
        this.phone,
        this.avatar,
        this.walletId,
        this.walletPoint,
        this.specializations,
        this.facebookLink,
        this.linkedinLink,
        this.twitterLink,
        this.youtubeLink,
    });

    AccountProfile copyWith({
        int? id,
        String? name,
        String? email,
        String? role,
        DateTime? dayOfBirth,
        String? gender,
        String? phone,
        String? avatar,
        double? walletId,
        double? walletPoint,
        List<String>? specializations,
        String? facebookLink,
        String? linkedinLink,
        String? twitterLink,
        String? youtubeLink,
    }) => 
        AccountProfile(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
            role: role ?? this.role,
            dayOfBirth: dayOfBirth ?? this.dayOfBirth,
            gender: gender ?? this.gender,
            phone: phone ?? this.phone,
            avatar: avatar ?? this.avatar,
            walletId: walletId ?? this.walletId,
            walletPoint: walletPoint ?? this.walletPoint,
            specializations: specializations ?? this.specializations,
            facebookLink: facebookLink ?? this.facebookLink,
            linkedinLink: linkedinLink ?? this.linkedinLink,
            twitterLink: twitterLink ?? this.twitterLink,
            youtubeLink: youtubeLink ?? this.youtubeLink,
        );

    factory AccountProfile.fromJson(Map<String, dynamic> json) => AccountProfile(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        dayOfBirth: json["dayOfBirth"] == null ? null : DateTime.parse(json["dayOfBirth"]),
        gender: json["gender"],
        phone: json["phone"],
        avatar: json["avatar"],
        walletId: json["walletId"]?.toDouble(),
        walletPoint: json["walletPoint"]?.toDouble(),
        specializations: json["specializations"] == null ? [] : List<String>.from(json["specializations"]!.map((x) => x)),
        facebookLink: json["facebookLink"],
        linkedinLink: json["linkedinLink"],
        twitterLink: json["twitterLink"],
        youtubeLink: json["youtubeLink"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "dayOfBirth": "${dayOfBirth!.year.toString().padLeft(4, '0')}-${dayOfBirth!.month.toString().padLeft(2, '0')}-${dayOfBirth!.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "phone": phone,
        "avatar": avatar,
        "walletId": walletId,
        "walletPoint": walletPoint,
        "specializations": specializations == null ? [] : List<dynamic>.from(specializations!.map((x) => x)),
        "facebookLink": facebookLink,
        "linkedinLink": linkedinLink,
        "twitterLink": twitterLink,
        "youtubeLink": youtubeLink,
    };
}

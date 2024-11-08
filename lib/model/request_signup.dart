import 'dart:convert';

RequestSignUp requestSignUpFromJson(String str) =>
    RequestSignUp.fromJson(json.decode(str));

String requestSignUpToJson(RequestSignUp data) => json.encode(data.toJson());

class RequestSignUp {
  String? email;
  String? password;
  String? name;
  String? role;

  RequestSignUp({
    this.email,
    this.password,
    this.name,
    this.role = 'STUDENT',
  });

  RequestSignUp copyWith({
    String? email,
    String? password,
    String? name,
    String? role,
  }) =>
      RequestSignUp(
        email: email ?? this.email,
        password: password ?? this.password,
        name: name ?? this.name,
        role: role ?? this.role,
      );

  factory RequestSignUp.fromJson(Map<String, dynamic> json) => RequestSignUp(
        email: json["email"],
        password: json["password"],
        name: json["name"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "name": name,
        "role": role,
      };
}

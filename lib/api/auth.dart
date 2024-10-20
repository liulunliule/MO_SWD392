import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mo_swd392/model/request_signup.dart';

const loginEndpoint = 'http://167.71.220.5:8080/auth/login';
const signUpEndpoint = 'http://167.71.220.5:8080/auth/register';

class AuthApi {
  static Future<bool> login(
      {required String email, required String password}) async {
    var url = Uri.parse(loginEndpoint);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"email": email, "password": password}),
    );
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future<bool> register({required RequestSignUp bodyRequest}) async {
    var url = Uri.parse(signUpEndpoint);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(bodyRequest.toJson()),
    );
    log(jsonEncode(bodyRequest.toJson()));
    if (response.statusCode == 201) {
      return true;
    }
    throw Exception(json.decode(response.body)['message']);
  }
}

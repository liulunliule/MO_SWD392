import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mo_swd392/model/request_signup.dart';

const loginEndpoint = 'http://167.71.220.5:8080/auth/login';
const signUpEndpoint = 'http://167.71.220.5:8080/auth/register';

class AuthApi {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

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
      String accessToken = json.decode(response.body)['accessToken'];
      String refreshToken = json.decode(response.body)['refreshToken'];
      //lưu token vào storage
      await _storage.write(key: 'accessToken', value: accessToken);
      await _storage.write(key: 'refreshToken', value: refreshToken);

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

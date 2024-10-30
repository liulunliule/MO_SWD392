import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mo_swd392/model/account_profile.dart';
import 'package:mo_swd392/model/achievement.dart';
import 'package:mo_swd392/model/request_signup.dart';

const loginEndpoint = 'http://167.71.220.5:8080/auth/login';
const signUpEndpoint = 'http://167.71.220.5:8080/auth/register';
const profileEndpoint = 'http://167.71.220.5:8080/account/profile';
const updateProfileEndpoint =
    'http://167.71.220.5:8080/account/profile/update-profile';
const getAchievementEndpoint =
    'http://167.71.220.5:8080/mentor/achievement/get';

const getSpecializationEndpoint =
    'http://167.71.220.5:8080/mentor/specialization/get';

const deleteAchievementEndpoint =
    'http://167.71.220.5:8080/mentor/achievement/delete/';

const updateSpecializationEndpoint =
    'http://167.71.220.5:8080/mentor/specialization/update';

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
      log(jsonEncode(response.body));
      String accessToken = json.decode(response.body)['accessToken'];
      String refreshToken = json.decode(response.body)['refreshToken'];
      String role = json.decode(response.body)['role'];
      //lưu token vào storage
      await _storage.write(key: 'accessToken', value: accessToken);
      await _storage.write(key: 'refreshToken', value: refreshToken);
      await _storage.write(key: 'role', value: role);
      await getProfile();

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

  static Future<AccountProfile> getProfile() async {
    var url = Uri.parse(profileEndpoint);
    String? accessToken = await _storage.read(key: 'accessToken');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
    );
    log(jsonEncode(response.body.toString()));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      String name = data['name'];
      await _storage.write(key: 'name', value: name);
      return AccountProfile.fromJson(data);
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future<AccountProfile> updateProfile(
      {required String accountId,
      required String name,
      required String phone}) async {
    var url = Uri.parse(updateProfileEndpoint);
    String? accessToken = await _storage.read(key: 'accessToken');
    final response = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode({
          "accountId": accountId,
          "name": name,
          "phone": phone,
        }));
    log(jsonEncode(response.body.toString()));
    if (response.statusCode == 200) {
      return AccountProfile.fromJson(jsonDecode(response.body)['data']);
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future<List<Achievement>> getAchievement() async {
    var url = Uri.parse(getAchievementEndpoint);
    String? accessToken = await _storage.read(key: 'accessToken');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
    );
    log(jsonEncode(response.body.toString()));
    if (response.statusCode == 200) {
      List<Achievement> listAchievement = [];
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)["data"];
        listAchievement =
            data.map((item) => Achievement.fromJson(item)).toList();
      }
      return listAchievement;
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future<bool> deleteAchievement({
    required String achievementId,
  }) async {
    var url = Uri.parse(deleteAchievementEndpoint + achievementId);
    String? accessToken = await _storage.read(key: 'accessToken');
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
    );
    log(jsonEncode(response.body.toString()));
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future<List<String>> getSpecialization() async {
    var url = Uri.parse(getSpecializationEndpoint);
    String? accessToken = await _storage.read(key: 'accessToken');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
    );
    log(jsonEncode(response.body.toString()));
    if (response.statusCode == 200) {
      List<String> listData = [];
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)["data"];
        listData = data.map((item) => item.toString()).toList();
      }
      return listData;
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future updateSpecialization({required List<String> listData}) async {
    var url = Uri.parse(updateSpecializationEndpoint);
    String? accessToken = await _storage.read(key: 'accessToken');
    final response = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode({"enumList": listData}));
    log(jsonEncode(response.body.toString()));

    // if (response.statusCode == 200) {
    //   return AccountProfile.fromJson(jsonDecode(response.body)['data']);
    // }
    // throw Exception(json.decode(response.body)['message']);
  }
}

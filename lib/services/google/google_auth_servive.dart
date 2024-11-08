import 'dart:convert'; // Import for JSON encoding and decoding
import 'dart:developer'; // Import for log function
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import '../../api/auth.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  String? ggemail;
  String? ggname;
  String? ggpicture;

  // Hàm đăng nhập với Google
  Future<User?> signInWithGoogle() async {
    try {
      // Bắt đầu quá trình đăng nhập Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // Người dùng hủy đăng nhập
      }

      // Lấy thông tin xác thực từ tài khoản Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // In ra accessToken và idToken
      print("Access Token: ${googleAuth.accessToken}");
      print("ID Token: ${googleAuth.idToken}");

      // Lưu accessToken vào Flutter Secure Storage
      await _storage.write(key: 'accessToken', value: googleAuth.accessToken);

      // Giải nén `idToken`
      Map<String, dynamic> decodedToken =
          JwtDecoder.decode(googleAuth.idToken!);
      print("Thông tin giải nén từ idToken:");
      print(decodedToken);

      ggemail = decodedToken['email'];
      ggname = decodedToken['name'];
      ggpicture = decodedToken['picture'];
      print("data :");
      print("ggemail: $ggemail");
      print("ggname: $ggname");
      print("ggpicture: $ggpicture");

      // Tạo credential từ Google Auth
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await loginBE();

      // Đăng nhập vào Firebase bằng Google credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential
          .user; // Trả về thông tin người dùng đăng nhập thành công
    } catch (e) {
      print("Lỗi đăng nhập Google: $e");
      return null;
    }
  }

  // Hàm đăng nhập với Backend
  Future<bool> loginBE() async {
    var url = Uri.parse('http://167.71.220.5:8080/auth/login/google/mobile');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode({"email": ggemail, "name": ggname, "picture": ggpicture}),
    );

    if (response.statusCode == 200) {
      log('Response body: ${response.body}'); // Log the response body
      String accessToken = json.decode(response.body)['accessToken'];
      String refreshToken = json.decode(response.body)['refreshToken'];
      String role = json.decode(response.body)['role'];
      print("accessToken of circuit: $accessToken");
      print("refreshToken of circuit: $refreshToken");
      print("role of circuit: $role");

      // Lưu token vào storage
      await _storage.write(key: 'accessToken', value: accessToken);
      await _storage.write(key: 'refreshToken', value: refreshToken);
      await _storage.write(key: 'role', value: role);
      await AuthApi.getProfile();

      return true;
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }

  // Hàm đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}

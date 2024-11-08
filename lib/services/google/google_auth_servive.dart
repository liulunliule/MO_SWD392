import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

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

      // Tạo credential từ Google Auth
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

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

  // Hàm đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}

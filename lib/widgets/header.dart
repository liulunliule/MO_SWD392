import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/google/google_auth_servive.dart';

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  bool _isLoggedIn = false;
  String userName = "User";

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? accessToken = await _storage.read(key: 'accessToken');
    String? storedName = await _storage.read(key: 'name');
    setState(() {
      _isLoggedIn = accessToken != null;
      userName = storedName ?? "User";
    });
  }

  Future<void> _logout(BuildContext context) async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    await _storage.delete(key: 'role');
    await _storage.delete(key: 'name');
    await GoogleAuthService().signOut();
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      height: 200,
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.green[700],
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            right: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.green[700],
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/notifications');
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                              size: 40,
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Hello,\n $userName",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: _isLoggedIn
                      ? ElevatedButton(
                          onPressed: () {
                            _logout(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text("Logout"),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Login
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/signIn');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text("Login"),
                            ),
                            SizedBox(width: 10),
                            //Sign Up
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/signUp');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text("Sign Up"),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

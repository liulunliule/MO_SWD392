import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  // GlobalKey để truy cập Navigator
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // FCM
  static Future<void> init() async {
    // Yêu cầu quyền iOS
    await _firebaseMessaging.requestPermission();

    // Lấy token FCM
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // Xử lý khi nhận được tin nhắn khi app đang mở
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          "Received message: ${message.notification?.title} - ${message.notification?.body}");
    });

    // Xử lý khi người dùng nhấn vào thông báo và mở ứng dụng
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message clicked!");
      _handleMessageNavigation(message);
    });

    // Kiểm tra khi app được mở từ thông báo
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageNavigation(initialMessage);
    }
  }

  // Hàm điều hướng đến trang '/notificationsFirebase'
  static void _handleMessageNavigation(RemoteMessage message) {
    navigatorKey.currentState?.pushNamed('/notificationsFirebase');
  }
}

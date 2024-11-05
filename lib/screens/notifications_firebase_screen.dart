import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationFirebaseScreen extends StatefulWidget {
  @override
  _NotificationFirebaseScreenState createState() =>
      _NotificationFirebaseScreenState();
}

class _NotificationFirebaseScreenState
    extends State<NotificationFirebaseScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  List<RemoteMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _initializeFCM();
  }

  Future<void> _initializeFCM() async {
    // Đăng ký nhận thông báo
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _messages.add(message);
      });
      print('Message received: ${message.notification?.title}');
    });

    // Xử lý thông báo khi ứng dụng đang chạy ở nền
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new message opened the app: ${message.messageId}');
    });

    // Lấy thông báo từ Firebase khi ứng dụng khởi động
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      setState(() {
        _messages.add(initialMessage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Stack(
          children: [
            // Vòng tròn nền trên cùng và dưới
            Positioned(
              top: -110,
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
              bottom: -65,
              right: -25,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Nội dung AppBar
            AppBar(
              title: Text(
                'Firebase Notifications',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color.fromARGB(189, 15, 137, 19),
              elevation: 0,
              foregroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: _messages.isEmpty
          ? Center(child: Text('No notifications available'))
          : ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return buildNotificationItem(
                  title: message.notification?.title ?? 'No Title',
                  body: message.notification?.body ?? 'No Body',
                  time: message.sentTime?.toString() ?? '',
                );
              },
            ),
    );
  }

  Widget buildNotificationItem({
    required String title,
    required String body,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.notifications, color: Colors.white),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

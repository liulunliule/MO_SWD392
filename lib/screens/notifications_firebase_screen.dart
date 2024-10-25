import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import FlutterSecureStorage
import '../layouts/second_layout.dart';

class NotificationFirebaseScreen extends StatefulWidget {
  @override
  _NotificationFirebaseScreenState createState() =>
      _NotificationFirebaseScreenState();
}

class _NotificationFirebaseScreenState
    extends State<NotificationFirebaseScreen> {
  final FlutterSecureStorage _storage =
      FlutterSecureStorage(); // Khởi tạo FlutterSecureStorage
  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      // Lấy accessToken từ storage
      String? accessToken = await _storage.read(key: 'accessToken');
      if (accessToken != null) {
        final response = await http.get(
          Uri.parse('http://167.71.220.5:8080/notification/all'),
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            notifications = data['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          print('Failed to load notifications');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print('Access token not found');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SecondLayout(
      title: 'Notifications Firebase',
      currentPage: 'notificationsFirebase',
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(child: Text('No notifications available'))
              : ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return buildNotificationItem(
                      context,
                      message: notification['message'],
                      status: notification['status'],
                      time: notification['date'],
                    );
                  },
                ),
    );
  }

  Widget buildNotificationItem(BuildContext context,
      {required String message, required String status, required String time}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person,
                color: Colors.white), // Placeholder for profile icon
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(color: getStatusColor(status)),
                ),
              ],
            ),
          ),
          Text(
            formatTime(time),
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'PROCESSING':
        return Colors.orange;
      case 'SUCCESSFUL':
        return Colors.green;
      case 'PENDING':
        return Colors.blue;
      case 'DECLINED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String formatTime(String time) {
    final dateTime = DateTime.parse(time);
    return '${dateTime.hour}:${dateTime.minute} ${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }
}

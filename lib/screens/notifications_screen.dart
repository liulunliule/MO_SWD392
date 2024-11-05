import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import FlutterSecureStorage
import '../layouts/second_layout.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  List<dynamic> notifications = [];
  bool isLoading = true;
  String? role;

  @override
  void initState() {
    super.initState();
    fetchUserRole(); // Fetch user role first
  }

  Future<void> fetchUserRole() async {
    String? storedRole = await _storage.read(key: 'role');
    setState(() {
      role = storedRole;
    });
    fetchNotifications();
  }

  void _showMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> fetchNotifications() async {
    try {
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

  Future<void> approveNotification(int bookingId) async {
    try {
      String? accessToken = await _storage.read(key: 'accessToken');
      final url = 'http://167.71.220.5:8080/mentor/booking/approve/$bookingId';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        print("Notification approved successfully.");
        fetchNotifications(); // Refresh notifications after approval
        _showMessage(responseData['message']); // Show success message
      } else {
        _showMessage(responseData['message']); // Show error message
      }
    } catch (e) {
      print("Error approving notification: $e");
      _showMessage("An error occurred while approving the notification.");
    }
  }

  Future<void> rejectNotification(int bookingId) async {
    try {
      String? accessToken = await _storage.read(key: 'accessToken');
      final url = 'http://167.71.220.5:8080/mentor/booking/reject/$bookingId';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        print("Notification rejected successfully.");
        fetchNotifications(); // Refresh notifications after rejection
        _showMessage(responseData['message']); // Show success message
      } else {
        _showMessage(responseData['message']); // Show error message
      }
    } catch (e) {
      print("Error rejecting notification: $e");
      _showMessage("An error occurred while rejecting the notification.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SecondLayout(
      title: 'Notifications',
      currentPage: 'notifications',
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
                      index: index,
                      message: notification['message'],
                      status: notification['status'],
                      time: notification['date'],
                      bookingId: notification['bookingId'],
                    );
                  },
                ),
    );
  }

  Widget buildNotificationItem(
    BuildContext context, {
    required int index,
    required String message,
    required String status,
    required String time,
    required int bookingId,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          status,
                          style: TextStyle(color: getStatusColor(status)),
                        ),
                        Text(
                          formatTime(time),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    if (status == 'PROCESSING' && role == 'MENTOR')
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => approveNotification(bookingId),
                            child: Text('Approve',
                                style: TextStyle(color: Colors.green)),
                          ),
                          TextButton(
                            onPressed: () => rejectNotification(bookingId),
                            child: Text('Reject',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
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

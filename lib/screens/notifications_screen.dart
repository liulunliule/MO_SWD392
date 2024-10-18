import 'package:flutter/material.dart';
import '../layouts/second_layout.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecondLayout(
      title: 'Notifications',
      currentPage: 'notifications',
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Example notification items
          buildNotificationItem(
            context,
            message: 'You have a new booking request!',
            status: 'Processing',
            time: '9:42 AM',
          ),
          buildNotificationItem(
            context,
            message: 'You have a new booking request!',
            status: 'Processing',
            time: '9:00 AM',
          ),
          buildNotificationItem(
            context,
            message: 'You have a new booking request!',
            status: 'Processing',
            time: '6:00 AM',
          ),
          buildNotificationItem(
            context,
            message: 'You have a new booking request!',
            status: 'Processing',
            time: '5:00 AM',
          ),
          buildNotificationItem(
            context,
            message: 'Your booking request has been confirmed.',
            status: 'Successful',
            time: '4:20 AM',
          ),
          buildNotificationItem(
            context,
            message: 'Your booking request has been confirmed.',
            status: 'Successful',
            time: '4:28 AM',
          ),
          buildNotificationItem(
            context,
            message: 'You have declined the booking request.',
            status: 'Declined',
            time: '2:25 PM',
          ),
          buildNotificationItem(
            context,
            message: 'You have declined the booking request.',
            status: 'Declined',
            time: '2:00 PM',
          ),
        ],
      ),
    );
  }

  // Widget to build each notification item
  Widget buildNotificationItem(BuildContext context,
      {required String message,
        required String status,
        required String time}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.white), // Placeholder for profile icon
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
            time,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Function to determine status color
  Color getStatusColor(String status) {
    switch (status) {
      case 'Processing':
        return Colors.orange;
      case 'Successful':
        return Colors.green;
      case 'Declined':
        return Colors.red;
      default:
        return Colors.grey; // Default color if status doesn't match
    }
  }
}

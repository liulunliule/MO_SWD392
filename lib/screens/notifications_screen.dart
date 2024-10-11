import 'package:flutter/material.dart';
import '../layouts/second_layout.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecondLayout(
      title: 'Notifications',
      currentPage: 'notifications',
      body: Center(
        child: Text(
          'Nội dung trang Notifications ở đây',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

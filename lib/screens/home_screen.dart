import 'package:flutter/material.dart';
import '../layouts/sticky_layout.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StickyLayout(
      title: 'Home', // Bạn có thể thêm tiêu đề nếu cần
      currentPage: 'home',
      body: Center(
        child: Text(
          'Nội dung trang Home ở đây',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

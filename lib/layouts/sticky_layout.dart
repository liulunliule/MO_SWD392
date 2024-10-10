import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class StickyLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final String currentPage;

  StickyLayout({required this.title, required this.body, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0), // Giữ nguyên chiều cao
        child: Header(), // Giữ nguyên header
      ),
      body: body, // Sử dụng body từ tham số
      bottomNavigationBar: Footer(currentPage: currentPage), // Footer
    );
  }
}

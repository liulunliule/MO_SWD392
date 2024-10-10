import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class StickyLayout extends StatelessWidget {
  final String currentPage;

  StickyLayout({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0),
        child: Header(),
      ),
      body: Center(
        child: Text(
          'Nội dung trang ở đây',
          style: TextStyle(fontSize: 18),
        ),
      ),
      bottomNavigationBar: Footer(currentPage: currentPage),
    );
  }
}

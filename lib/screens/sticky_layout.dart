import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class StickyLayout extends StatelessWidget {
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
      bottomNavigationBar: Footer(),
    );
  }
}

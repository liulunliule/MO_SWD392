import 'package:flutter/material.dart';
import '../widgets/footer.dart'; // Đảm bảo đường dẫn đúng đến file Footer
import '../widgets/header.dart'; // Đảm bảo đường dẫn đúng đến file Header

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(),
          Expanded(
            child: Center(
              child: Text(
                'This is the main content area',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(),
    );
  }
}

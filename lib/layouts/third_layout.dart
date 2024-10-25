import 'package:flutter/material.dart';
import '../widgets/footer.dart';

class ThirdLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final String currentPage;

  ThirdLayout(
      {required this.title, required this.body, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          title: Text(title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: body,
      bottomNavigationBar: Footer(currentPage: currentPage),
    );
  }
}

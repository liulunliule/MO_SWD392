import 'package:flutter/material.dart';
import '../widgets/footer.dart';

class SecondLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final String currentPage;

  SecondLayout(
      {required this.title, required this.body, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          title: Text(title),
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

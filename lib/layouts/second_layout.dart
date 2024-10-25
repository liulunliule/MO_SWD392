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
        child: Stack(
          children: [
            // Background with circles
            Positioned(
              top: -110,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -65,
              right: -25,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // AppBar content
            AppBar(
              title: Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color.fromARGB(189, 15, 137, 19),
              elevation: 0,
              foregroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: body,
      bottomNavigationBar: Footer(currentPage: currentPage),
    );
  }
}

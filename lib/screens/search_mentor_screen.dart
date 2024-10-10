import 'package:flutter/material.dart';
import '../layouts/second_layout.dart';

class SearchMentorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecondLayout(
      title: 'Search Mentor',
      currentPage: 'search',
      body: Center(
        child: Text(
          'Nội dung trang Search Mentor ở đây',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
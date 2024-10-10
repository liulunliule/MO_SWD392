import 'package:flutter/material.dart';
import '../layouts/sticky_layout.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StickyLayout(
      currentPage: 'home',
    );
  }
}

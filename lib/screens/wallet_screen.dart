import 'package:flutter/material.dart';
import '../layouts/second_layout.dart';

class WalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecondLayout(
      title: 'Wallet',
      currentPage: 'wallet',
      body: Center(
        child: Text(
          'Nội dung trang Wallet ở đây',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

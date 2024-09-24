import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Container(
        height: 60.0,
        child: Row(
          children: [
            Expanded(
              child: IconButton(
                icon: Icon(Icons.home_outlined),
                onPressed: () {
                  // Home
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  //Search
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.account_balance_wallet_outlined),
                onPressed: () {
                  //Wallet
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.calendar_today_outlined),
                onPressed: () {
                  //Calendar
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.person_outline),
                onPressed: () {
                  //Profile
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

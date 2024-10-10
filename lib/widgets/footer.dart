import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final String currentPage;
  Footer({required this.currentPage});
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
                icon: Icon(Icons.home_outlined,color: currentPage == 'home' ? Colors.green : Colors.black,),
                onPressed: () {
                  // Home
                  Navigator.pushReplacementNamed(context, '/');
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

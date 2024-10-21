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
                icon: Icon(
                  Icons.home_outlined,
                  color: currentPage == 'home' ? Colors.green : Colors.black,
                ),
                onPressed: () {
                  // Home
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: currentPage == 'search' ? Colors.green : Colors.black,
                ),
                onPressed: () {
                  //Search
                  Navigator.pushReplacementNamed(context, '/search');
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: currentPage == 'wallet' ? Colors.green : Colors.black,
                ),
                onPressed: () {
                  //Wallet
                  Navigator.pushReplacementNamed(context, '/wallet');
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(
                  Icons.calendar_today_outlined,
                  color:
                      currentPage == 'schedule' ? Colors.green : Colors.black,
                ),
                onPressed: () {
                  //Calendar
                  Navigator.pushReplacementNamed(context, '/schedule');
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.person_outline),
                onPressed: () {
                  //Profile
                  Navigator.pushReplacementNamed(context, '/profile');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

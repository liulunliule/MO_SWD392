import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Footer extends StatefulWidget {
  final String currentPage;

  Footer({required this.currentPage});

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? accessToken = await _storage.read(key: 'accessToken');
    setState(() {
      _isLoggedIn = (accessToken != null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Container(
        height: 60.0,
        child: Row(
          children: [
            // Home button
            _buildButton(
              context,
              Icons.home_outlined,
              'home',
              () => Navigator.pushReplacementNamed(context, '/'),
            ),
            // Search button
            _buildButton(
              context,
              Icons.search,
              'search',
              () => Navigator.pushReplacementNamed(context, '/search'),
            ),
            // Schedule button (only visible if logged in)
            if (_isLoggedIn)
              _buildButton(
                context,
                Icons.calendar_today_outlined,
                'schedule',
                () => Navigator.pushReplacementNamed(context, '/schedule'),
              ),
            // Blog button (only visible if logged in)
            if (_isLoggedIn)
              _buildButton(
                context,
                Icons.article_outlined,
                'myBlog',
                () => Navigator.pushReplacementNamed(context, '/myBlog'),
              ),
            // Wallet button (only visible if logged in)
            if (_isLoggedIn)
              _buildButton(
                context,
                Icons.account_balance_wallet_outlined,
                'wallet',
                () => Navigator.pushReplacementNamed(context, '/wallet'),
              ),
            // Profile button
            Expanded(
              child: IconButton(
                icon: Icon(Icons.person_outline),
                onPressed: () {
                  if (_isLoggedIn) {
                    Navigator.pushReplacementNamed(context, '/profile');
                  } else {
                    Navigator.pushReplacementNamed(context, '/signIn');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm tạo nút IconButton
  Expanded _buildButton(BuildContext context, IconData icon, String page,
      VoidCallback onPressed) {
    return Expanded(
      child: IconButton(
        icon: Icon(
          icon,
          color: widget.currentPage == page
              ? const Color.fromARGB(255, 181, 237, 61)
              : Colors.black,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

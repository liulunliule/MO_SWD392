import 'package:flutter/material.dart';
import 'screens/notifications_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_mentor_screen.dart';
import 'screens/wallet_screen.dart';


class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/notifications':
        return MaterialPageRoute(builder: (_) => NotificationScreen());
      case '/search':
        return MaterialPageRoute(builder: (_) => SearchMentorScreen());
      case '/wallet':
        return MaterialPageRoute(builder: (_) => WalletScreen());

      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}

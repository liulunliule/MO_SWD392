import 'package:flutter/material.dart';
import 'package:mo_swd392/screens/achievement_screen.dart';
import 'package:mo_swd392/screens/achievement_screen.dart';
import 'package:mo_swd392/screens/mentor_profile_screen.dart';
import 'package:mo_swd392/screens/my_blog_screen.dart';
import 'package:mo_swd392/screens/notifications_firebase_screen.dart';
import 'package:mo_swd392/screens/update_my_blog.dart';
import 'package:mo_swd392/screens/profile_screen.dart';
import 'package:mo_swd392/screens/profile_screen.dart';
import 'package:mo_swd392/screens/specialization_screen.dart';
import '/screens/schedule_screen.dart';
import '/view/sign_in.dart';
import '/view/sign_up.dart';
import 'screens/notifications_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/search_mentor_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/blog_detail_screen.dart';
import 'screens/create_blog_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/notifications':
        return MaterialPageRoute(builder: (_) => NotificationScreen());
      case '/notificationsFirebase':
        return MaterialPageRoute(builder: (_) => NotificationFirebaseScreen());
      case '/search':
        return MaterialPageRoute(builder: (_) => SearchMentorScreen());
      case '/wallet':
        String accessToken = '';
        return MaterialPageRoute(
            builder: (_) => WalletScreen(accessToken: accessToken));
      case '/mentorProfile':
        final accountId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => MentorProfileScreen(accountId: accountId),
        );
      case '/schedule':
        return MaterialPageRoute(builder: (_) => ScheduleScreen());
      case '/signIn':
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case '/signUp':
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case '/blogDetail':
        final blogId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => BlogDetailScreen(blogId: blogId),
        );
      case '/myBlog':
        return MaterialPageRoute(builder: (_) => MyBlogScreen());
      case '/createBlog':
        return MaterialPageRoute(builder: (_) => CreateBlogScreen());
      case '/updateBlog':
        final blogId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => UpdateMyBlogScreen(blogId: blogId),
        );
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case '/achievement':
        return MaterialPageRoute(builder: (_) => AchievementScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case '/achievement':
        return MaterialPageRoute(builder: (_) => AchievementScreen());
      case '/specialization':
        return MaterialPageRoute(builder: (_) => SpecializationScreen());
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../layouts/sticky_layout.dart';
import './blog/blog_tab.dart';
import './topic/topic_tab.dart';
import './my_topic/my_topic_tab.dart';

class HomeScreen extends StatelessWidget {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<bool> _isMentor() async {
    String? role = await _storage.read(key: 'role');
    return role == 'MENTOR';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isMentor(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        bool isMentor = snapshot.data ?? false;

        return DefaultTabController(
          length: isMentor ? 3 : 2,
          child: StickyLayout(
            title: 'Home',
            currentPage: 'home',
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom Tab Bar with Wider Indicator
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TabBar(
                      tabs: [
                        Tab(text: 'Blogs'),
                        Tab(text: 'Topics'),
                        if (isMentor) Tab(text: 'My Topics'),
                      ],
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.green[800],
                      indicator: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelStyle:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      unselectedLabelStyle: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16),
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: TabBarView(
                      children: [
                        BlogTab(),
                        TopicTab(),
                        if (isMentor) MyTopicTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

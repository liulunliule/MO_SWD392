import 'package:flutter/material.dart';
import '../../../api/api_topic.dart';

class TopicTab extends StatefulWidget {
  @override
  _TopicTabState createState() => _TopicTabState();
}

class _TopicTabState extends State<TopicTab> {
  List<Map<String, dynamic>> topics = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  Future<void> fetchTopics() async {
    final fetchedTopics = await ApiTopic.fetchTopics();
    setState(() {
      topics = fetchedTopics;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: topics.length,
                    itemBuilder: (context, index) {
                      final topic = topics[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topic['topicName'],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800]),
                              ),
                              SizedBox(height: 5),
                              Text(
                                topic['description'],
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Xóa phần hiển thị nút "Add New Topic"
        ],
      ),
    );
  }
}

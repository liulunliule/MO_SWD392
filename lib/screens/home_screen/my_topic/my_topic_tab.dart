import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../api/api_topic.dart';

class MyTopicTab extends StatefulWidget {
  @override
  _MyTopicTabState createState() => _MyTopicTabState();
}

class _MyTopicTabState extends State<MyTopicTab> {
  List<Map<String, dynamic>> myTopics = [];
  bool isLoading = true;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchMyTopics();
  }

  Future<void> fetchMyTopics() async {
    final fetchedMyTopics = await ApiTopic.fetchMyTopics();
    setState(() {
      myTopics = fetchedMyTopics;
      isLoading = false;
    });
  }

  void _showCreateTopicDialog(
      {String? topicName, String? description, int? topicId}) {
    String newTopicName = topicName ?? '';
    String newDescription = description ?? '';
    String errorMessage = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            topicId == null ? 'Create New Topic' : 'Edit Topic',
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Topic Name',
                  labelStyle: TextStyle(color: Colors.green),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                onChanged: (value) {
                  newTopicName = value;
                },
                controller: TextEditingController(text: newTopicName),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.green),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                onChanged: (value) {
                  newDescription = value;
                },
                controller: TextEditingController(text: newDescription),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text(topicId == null ? 'Create' : 'Update'),
              onPressed: () async {
                setState(() {
                  errorMessage = '';
                });

                if (newTopicName.isEmpty || newDescription.isEmpty) {
                  setState(() {
                    errorMessage = 'Please fill in all fields.';
                  });
                  return;
                }

                bool success;
                if (topicId == null) {
                  success = await ApiTopic.createTopic(
                    topicName: newTopicName,
                    description: newDescription,
                  );
                } else {
                  success = await ApiTopic.updateTopic(
                    topicId: topicId,
                    topicName: newTopicName,
                    description: newDescription,
                  );
                }

                if (success) {
                  fetchMyTopics();
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    errorMessage =
                        'Failed to ${topicId == null ? 'create' : 'update'} topic';
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(int topicId) async {
    bool? shouldDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this topic?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      bool success = await ApiTopic.deleteTopic(topicId);
      if (success) {
        fetchMyTopics();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete topic')),
        );
      }
    }
  }

  Future<void> _onAddTopicPressed() async {
    String? role = await _storage.read(key: 'role');
    if (role != 'MENTOR') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Access Denied'),
            content: Text('You must be a mentor to use this feature.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      _showCreateTopicDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : myTopics.isEmpty
                    ? Center(
                        child: Text(
                          'You must be logged in with the role of MENTOR to view topics.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: myTopics.length,
                        itemBuilder: (context, index) {
                          final topic = myTopics[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          topic['topicName'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[800],
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          topic['description'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Created at: ${topic['createdAt']}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () {
                                          _showCreateTopicDialog(
                                            topicName: topic['topicName'],
                                            description: topic['description'],
                                            topicId: topic['topicId'],
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () {
                                          _confirmDelete(topic['topicId']);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: ElevatedButton(
              onPressed: _onAddTopicPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Add New Topic',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../layouts/second_layout.dart';

class BlogDetailScreen extends StatefulWidget {
  final int blogId;

  BlogDetailScreen({required this.blogId});

  @override
  _BlogDetailScreenState createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  final _storage = FlutterSecureStorage();
  Map<String, dynamic>? blogDetail;
  bool isLoading = true;
  final TextEditingController _commentController = TextEditingController();
  String? storedName; // Variable to hold the stored name

  @override
  void initState() {
    super.initState();
    fetchBlogDetail();
    _getStoredName(); // Retrieve stored name
  }

  Future<void> _getStoredName() async {
    storedName = await _storage.read(key: 'name') ??
        'Anonymous'; // Fallback to 'Anonymous' if not found
  }

  Future<void> fetchBlogDetail() async {
    final url = "http://167.71.220.5:8080/blog/view/${widget.blogId}";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          blogDetail = data;
          isLoading = false;
        });
      } else {
        print('Failed to load blog detail: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> _postComment(String commentText) async {
    String? accessToken = await _storage.read(key: 'accessToken');
    if (accessToken == null) {
      print('Access token not found');
      return;
    }

    final url = "http://167.71.220.5:8080/comment/create";
    final body = jsonEncode({"blogId": widget.blogId, "comment": commentText});

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final newComment = {
          'authorName': storedName, // Use stored name
          'description': commentText,
        };
        setState(() {
          blogDetail!['comments'].add(newComment);
        });
      } else {
        print('Failed to post comment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while posting comment: $e');
    }
  }

  Future<void> _deleteComment(int commentId) async {
    String? accessToken = await _storage.read(key: 'accessToken');
    if (accessToken == null) {
      print('Access token not found');
      return;
    }

    final url = "http://167.71.220.5:8080/comment/delete/$commentId";

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          blogDetail!['comments']
              .removeWhere((comment) => comment['id'] == commentId);
        });
        _showMessage('Comment deleted successfully!');
      } else {
        print('Failed to delete comment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while deleting comment: $e');
    }
  }

  void _addComment() {
    final commentText = _commentController.text;
    if (commentText.isNotEmpty) {
      _postComment(commentText);
      _commentController.clear();
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SecondLayout(
      title: 'Blog Detail',
      currentPage: 'blog_detail',
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        blogDetail!['image'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      blogDetail!['title'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '#${blogDetail!['category']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      blogDetail!['description'],
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Comments:',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  blogDetail!['comments'].isEmpty
                      ? Text(
                          'No comments yet.',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 18),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: blogDetail!['comments'].length,
                          itemBuilder: (context, index) {
                            final comment = blogDetail!['comments'][index];
                            final isAuthor = comment['authorName'] ==
                                storedName; // Check if the user is the author
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.person,
                                          color: Colors.green[600], size: 24),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              comment['authorName'] ??
                                                  'Anonymous',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              comment['description'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isAuthor) // Show buttons if the user is the author
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () async {
                                                await _deleteComment(
                                                    comment['id']);
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.edit,
                                                  color: Colors.blue),
                                              onPressed: () {
                                                // Implement the update comment functionality here
                                                // You may want to show a dialog to get the new comment text
                                              },
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.green),
                        onPressed: _addComment,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

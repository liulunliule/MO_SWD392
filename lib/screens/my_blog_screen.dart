import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../layouts/second_layout.dart';

class MyBlogScreen extends StatefulWidget {
  @override
  _MyBlogScreenState createState() => _MyBlogScreenState();
}

class _MyBlogScreenState extends State<MyBlogScreen> {
  List<Map<String, dynamic>> blogs = [];
  bool isLoadingBlogs = true;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  // Fetch blogs from the API
  Future<void> fetchBlogs() async {
    final url = "http://167.71.220.5:8080/blog/view/by-account";
    try {
      String? accessToken = await _storage.read(key: 'accessToken');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          blogs = List<Map<String, dynamic>>.from(data)
              .where((blog) => blog['isDeleted'] == false)
              .toList();
          isLoadingBlogs = false; // Data loaded
        });
      } else {
        print('Failed to load blogs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SecondLayout(
      title: 'My Blog',
      currentPage: 'myBlog',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header for My Blogs
            Text(
              'My Blogs',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // List of blogs
            Expanded(
              child: isLoadingBlogs
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: blogs.length,
                      itemBuilder: (context, index) {
                        final blog = blogs[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to blog detail when tapped
                            Navigator.pushNamed(
                              context,
                              '/blogDetail',
                              arguments: blog['id'],
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Card(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              child: Row(
                                children: [
                                  // Image for the blog (Square)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        blog['image'],
                                        width:
                                            100, // Fixed width for square image
                                        height:
                                            100, // Fixed height for square image
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  // Blog details
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Blog title
                                          Text(
                                            blog['title'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          // Blog description
                                          Text(
                                            blog['description'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          // Like count
                                          Row(
                                            children: [
                                              Icon(Icons.thumb_up,
                                                  color: Colors.grey[600]),
                                              SizedBox(width: 5),
                                              Text(
                                                '${blog['likeCount']}',
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Edit button
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: TextButton(
                                      onPressed: () {
                                        // Navigate to edit blog screen
                                        Navigator.pushNamed(
                                          context,
                                          '/editBlog', // Add route for edit blog
                                          arguments: blog['id'], // Pass blog ID
                                        );
                                      },
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            // Add Blog Button
            ElevatedButton(
              onPressed: () {
                // Navigate to add blog screen
                Navigator.pushNamed(context, '/addBlog');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Add New Blog',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

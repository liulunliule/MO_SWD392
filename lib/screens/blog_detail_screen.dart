import 'package:flutter/material.dart';
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
  Map<String, dynamic>? blogDetail;
  bool isLoading = true;
  final TextEditingController _commentController =
      TextEditingController(); // Controller for comment input

  @override
  void initState() {
    super.initState();
    fetchBlogDetail();
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

  // Method to handle comment submission
  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        blogDetail!['comments'].add({
          'authorName':
              'You', // You can replace this with the actual user's name
          'description': _commentController.text,
        });
        _commentController.clear(); // Clear the input field after submission
      });
    }
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
                  // Blog image container
                  Container(
                    height: MediaQuery.of(context).size.height *
                        0.2, // 20% of screen height
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          30), // Rounded corners for the image
                      child: Image.network(
                        blogDetail!['image'],
                        fit: BoxFit.cover,
                        width:
                            double.infinity, // Fill the width of the container
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Title text only
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
                  SizedBox(
                      height: 10), // Add some space between title and category
                  // Blog category
                  Text(
                    '#${blogDetail!['category']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Blog description
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      blogDetail!['description'],
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ),
                  SizedBox(height: 15),
                  // Like count section with icon before the text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.thumb_up,
                          color: Colors.black54,
                          size: 24), // Neutral color for icon
                      SizedBox(width: 5), // Add space between icon and text
                      Text(
                        'Likes: ${blogDetail!['likeCount']}',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Comments section
                  Text(
                    'Comments:',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // Check if there are comments
                  blogDetail!['comments'].isEmpty
                      ? Text(
                          'No comments yet.',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 18),
                        )
                      : ListView.builder(
                          shrinkWrap:
                              true, // Allows ListView to take up only as much space as needed
                          physics:
                              NeverScrollableScrollPhysics(), // Prevents scrolling in the ListView
                          itemCount: blogDetail!['comments'].length,
                          itemBuilder: (context, index) {
                            final comment = blogDetail!['comments'][index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15), // Rounded corners for the comment
                                ),
                                elevation: 2, // Shadow effect
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.person,
                                          color: Colors.green[600],
                                          size: 24), // User icon
                                      SizedBox(
                                          width:
                                              10), // Space between icon and text
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // User name
                                            Text(
                                              comment['authorName'] ??
                                                  'Anonymous',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            // Comment text
                                            Text(
                                              comment[
                                                  'description'], // Displaying the comment text
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Icon buttons for actions
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                                Icons.thumb_up_alt_outlined,
                                                color: Colors.grey),
                                            onPressed: () {
                                              // Handle like action
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.reply,
                                                color: Colors.grey),
                                            onPressed: () {
                                              // Handle reply action
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
                  // Comment input field
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
                        onPressed: _addComment, // Call method to add comment
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

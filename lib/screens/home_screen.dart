import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../layouts/sticky_layout.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List to store blog data
  List<Map<String, dynamic>> blogs = [];

  // Loading state for blogs
  bool isLoadingBlogs = true;

  @override
  void initState() {
    super.initState();
    fetchBlogs(); // Fetch the blogs on initialization
  }

  // Fetch blogs from the API
  Future<void> fetchBlogs() async {
    final url = "http://167.71.220.5:8080/blog/view/all";
    try {
      final response = await http.get(Uri.parse(url));

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
    double screenHeight = MediaQuery.of(context).size.height;

    return StickyLayout(
      title: 'Home',
      currentPage: 'home',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blogs Header
              Text(
                'Blogs',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // List of blogs with redesigned layout
              Container(
                height: screenHeight * 0.6, // Adjust this value as needed
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
                                margin: EdgeInsets.symmetric(
                                    vertical: 10), // Margin for the card
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15), // Rounded corners
                                ),
                                elevation: 5, // Shadow for depth
                                child: Row(
                                  children: [
                                    // Image for the blog (Square)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10), // Added left padding
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          blog['image'],
                                          width:
                                              100, // Fixed width for square image
                                          height:
                                              100, // Fixed height for square image
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            // Return an empty container if image fails to load
                                            return Container();
                                          },
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
                                                fontSize:
                                                    18, // Adjusted font size
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
                                                fontSize:
                                                    14, // Adjusted font size
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            // Like count
                                            Row(
                                              children: [
                                                Icon(Icons.thumb_up,
                                                    color: Colors.grey[
                                                        600]), // Like icon
                                                SizedBox(width: 5),
                                                Text(
                                                  '${blog['likeCount']}',
                                                  style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize:
                                                        14, // Adjusted font size
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
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
            ],
          ),
        ),
      ),
    );
  }
}

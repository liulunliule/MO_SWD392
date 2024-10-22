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
    double screenWidth = MediaQuery.of(context).size.width;

    return StickyLayout(
      title: 'Home',
      currentPage: 'home',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blogs
              Text(
                'Blogs',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // List of blogs with enhanced styling
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
                                      20), // Rounded corners
                                ),
                                elevation: 10, // Increased shadow for depth
                                color: Color(0xFFF7F9F1), // Background color
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        20), // Match the mentor card style
                                    border: Border.all(
                                      color: Color(0xFFB5ED3D), // Border color
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Image for the blog
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        child: Image.network(
                                          blog['image'],
                                          width: double.infinity,
                                          height: screenHeight * 0.2,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 15.0),
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
                                                    20, // Adjusted font size
                                                color: Colors.black87,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            // Blog description
                                            Text(
                                              blog['description'],
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize:
                                                    18, // Adjusted font size
                                              ),
                                            ),
                                            SizedBox(height: 10),
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
                                                        18, // Adjusted font size
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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

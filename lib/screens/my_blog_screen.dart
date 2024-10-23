import 'package:flutter/material.dart';
import '../layouts/second_layout.dart';

class MyBlogScreen extends StatelessWidget {
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
            // Sample list of blog entries
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Sample count, replace with your data
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Blog title
                          Text(
                            'Blog Title $index', // Replace with dynamic title
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 5),
                          // Blog description
                          Text(
                            'This is a brief description of blog $index.',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          SizedBox(height: 10),
                          // Edit button
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Navigate to edit blog screen
                                Navigator.pushNamed(
                                  context,
                                  '/editBlog', // Add route for edit blog
                                  arguments: index, // Pass index or blog ID
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

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../api/api_my_blog.dart';
import '../layouts/second_layout.dart';

class MyBlogScreen extends StatefulWidget {
  @override
  _MyBlogScreenState createState() => _MyBlogScreenState();
}

class _MyBlogScreenState extends State<MyBlogScreen> {
  List<Map<String, dynamic>> blogs = [];
  bool isLoadingBlogs = true;
  final ApiMyBlog _apiMyBlog = ApiMyBlog();

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  Future<void> fetchBlogs() async {
    setState(() => isLoadingBlogs = true);
    blogs = await _apiMyBlog.fetchMyBlogs();
    setState(() => isLoadingBlogs = false);
  }

  Future<void> deleteBlog(String blogId) async {
    final success = await _apiMyBlog.deleteBlog(blogId);
    if (success) {
      fetchBlogs();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Blog deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete blog')),
      );
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
            Text(
              'My Blogs',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: isLoadingBlogs
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: blogs.length,
                      itemBuilder: (context, index) {
                        final blog = blogs[index];
                        return GestureDetector(
                          onTap: () async {
                            if (!blog['isDeleted']) {
                              final result = await Navigator.pushNamed(
                                context,
                                '/blogDetail',
                                arguments: blog['id'],
                              );
                              if (result == true) {
                                fetchBlogs();
                              }
                            }
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
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        blog['image'],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container();
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            blog['title'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            '#${blog['category']}',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            blog['description'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          blog['isDeleted']
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'Deleted',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          '/updateBlog',
                                                          arguments: blog['id'],
                                                        ).then((result) {
                                                          if (result == true) {
                                                            fetchBlogs();
                                                          }
                                                        });
                                                      },
                                                      child: Text(
                                                        'Update',
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    TextButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialog(
                                                            title: Text(
                                                                'Delete Blog'),
                                                            content: Text(
                                                                'Are you sure you want to delete this blog?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Cancel'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  deleteBlog(blog[
                                                                          'id']
                                                                      .toString());
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Delete'),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color: Colors.red),
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
            ElevatedButton(
              onPressed: () async {
                final result =
                    await Navigator.pushNamed(context, '/createBlog');
                if (result == true) {
                  fetchBlogs();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
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

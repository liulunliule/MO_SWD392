import 'package:flutter/material.dart';
import '../../../api/api_blog.dart';

class BlogTab extends StatefulWidget {
  @override
  _BlogTabState createState() => _BlogTabState();
}

class _BlogTabState extends State<BlogTab> {
  List<Map<String, dynamic>> blogs = [];
  bool isLoadingBlogs = true;

  @override
  void initState() {
    super.initState();
    loadBlogs();
  }

  Future<void> loadBlogs() async {
    setState(() => isLoadingBlogs = true);
    blogs = await fetchBlogs();
    setState(() => isLoadingBlogs = false);
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingBlogs
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              final blog = blogs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/blogDetail',
                      arguments: blog['id']);
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
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  blog['title'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '#${blog['category']}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  blog['description'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.thumb_up,
                                        color: Colors.grey[600]),
                                    SizedBox(width: 5),
                                    Text(
                                      '${blog['likeCount']}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[500]),
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
          );
  }
}

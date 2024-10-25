import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
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
          blogs = List<Map<String, dynamic>>.from(data);
          isLoadingBlogs = false; // Data loaded
        });
      } else {
        print('Failed to load blogs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  // Function to delete a blog (mark as deleted)
  Future<void> deleteBlog(String blogId) async {
    final url = "http://167.71.220.5:8080/blog/delete/$blogId";
    try {
      String? accessToken = await _storage.read(key: 'accessToken');
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 202 || response.statusCode == 200) {
        fetchBlogs();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Blog deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to delete blog: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error occurred while deleting blog: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while deleting blog')),
      );
    }
  }

  // Show the update popup
  void _showUpdatePopup(Map<String, dynamic> blog) async {
    bool? result = await showDialog(
      context: context,
      builder: (context) => UpdateBlogPopup(blog: blog),
    );
    if (result == true) {
      fetchBlogs(); // Refresh blogs if update was successful
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
                            // Navigate to blog detail when tapped, only if not deleted
                            if (!blog['isDeleted']) {
                              Navigator.pushNamed(
                                context,
                                '/blogDetail',
                                arguments: blog['id'],
                              );
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
                                  // Image for the blog (Square)
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
                                          return Container(); // Handle image error
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
                                          SizedBox(height: 10),
                                          // If blog is deleted, show "Deleted" label
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
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    // Update button
                                                    TextButton(
                                                      onPressed: () {
                                                        _showUpdatePopup(blog);
                                                      },
                                                      child: Text(
                                                        'Update',
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    // Delete button
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
            // Add Blog Button
            ElevatedButton(
              onPressed: () {
                // Navigate to add blog screen using the router
                Navigator.pushNamed(
                    context, '/createBlog'); // Route to create a new blog
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

class UpdateBlogPopup extends StatefulWidget {
  final Map<String, dynamic> blog;

  UpdateBlogPopup({required this.blog});

  @override
  _UpdateBlogPopupState createState() => _UpdateBlogPopupState();
}

class _UpdateBlogPopupState extends State<UpdateBlogPopup> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  File? _image;
  bool isLoading = false;
  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.blog['title']);
    descriptionController =
        TextEditingController(text: widget.blog['description']);
  }

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Method to upload an image to Firebase Storage
  Future<String?> _uploadImageToFirebase(File image) async {
    try {
      String fileName = path.basename(image.path);
      Reference storageRef =
          FirebaseStorage.instance.ref().child('blog_images/$fileName');
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Method to update the blog
  Future<void> _updateBlog() async {
    String? accessToken = await _storage.read(key: 'accessToken');
    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Access token not available')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    String? imageUrl = widget.blog['image'];
    if (_image != null) {
      imageUrl = await _uploadImageToFirebase(_image!);
    }

    String apiUrl = "http://167.71.220.5:8080/blog/update/${widget.blog['id']}";
    Map<String, dynamic> blogData = {
      "title": titleController.text,
      "description": descriptionController.text,
      "image": imageUrl ?? "",
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(blogData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Blog updated successfully')),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update blog')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating blog: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Blog'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Upload Image'),
            ),
            if (_image != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Image.file(_image!,
                    height: 150, width: double.infinity, fit: BoxFit.cover),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : _updateBlog,
          child: isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text('Update'),
        ),
      ],
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;
import '/resource/color_const.dart';
import '/resource/form_field_widget.dart';
import '/resource/reponsive_utils.dart';
import '/resource/text_style.dart';
import '../layouts/second_layout.dart';

class UpdateMyBlogScreen extends StatefulWidget {
  final int blogId; // Accept blog ID as a parameter

  UpdateMyBlogScreen({required this.blogId});

  @override
  _UpdateMyBlogScreenState createState() => _UpdateMyBlogScreenState();
}

class _UpdateMyBlogScreenState extends State<UpdateMyBlogScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final _storage = FlutterSecureStorage();
  File? _image;
  String? _currentImageUrl;
  String? selectedCategory;
  bool isLoading = false;
  List<String> categories = [];
  Map<String, bool> selectedFields = {};

  @override
  void initState() {
    super.initState();
    fetchBlogDetails(); // Fetch blog details to populate the fields
    _fetchCategories(); // Fetch categories
  }

  // Fetch categories from the API
  Future<void> _fetchCategories() async {
    final response = await http
        .get(Uri.parse("http://167.71.220.5:8080/blog/category/get-all"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['code'] == 200) {
        setState(() {
          categories = List<String>.from(data['data']);
          for (var category in categories) {
            selectedFields[category] = false; // Initialize selection state
          }
        });
      }
    }
  }

  // Fetch the blog details
  Future<void> fetchBlogDetails() async {
    String? accessToken = await _storage.read(key: 'accessToken');
    final url = "http://167.71.220.5:8080/blog/view/${widget.blogId}";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final blogData = jsonDecode(response.body)['data'];
        setState(() {
          titleController.text = blogData['title'];
          descriptionController.text = blogData['description'];
          _currentImageUrl = blogData['image'];
          selectedCategory = blogData['category']; // Set the current category
          if (selectedCategory != null) {
            selectedFields[selectedCategory!] = true; // Mark as selected
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch blog details')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching blog details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SecondLayout(
      title: 'Update Blog',
      currentPage: 'update blog',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Your Blog',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Title input field
              FormFieldWidget(
                controllerEditting: titleController,
                labelText: 'Blog Title',
                borderColor: Colors.grey,
                forcusColor: ColorsManager.primary,
                padding: 20,
                radiusBorder: 20,
                setValueFunc: (value) {},
              ),
              SizedBox(height: 16),

              // Description input field
              FormFieldWidget(
                controllerEditting: descriptionController,
                labelText: 'Blog Description',
                borderColor: Colors.grey,
                forcusColor: ColorsManager.primary,
                padding: 20,
                radiusBorder: 20,
                setValueFunc: (value) {},
              ),
              SizedBox(height: 16),
              if (_currentImageUrl != null && _image == null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      _currentImageUrl!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(); // Handle image loading error
                      },
                    ),
                  ),
                ),

              // Category selection
              Text(
                "Select Category",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFields
                            .updateAll((key, value) => false); // Reset all
                        selectedFields[category] = true; // Select this field
                        selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: selectedFields[category] ?? false
                            ? Color(0xFFB5ED3D) // Green when selected
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selectedFields[category] ?? false
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: selectedFields[category] ?? false
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // File upload button
              Center(
                child: ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Upload New Image (Optional)'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: ColorsManager.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

              // Preview the selected image
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _image!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              SizedBox(height: 20),

              // Update Blog button
              Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : _updateBlog,
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text('Update Blog'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: ColorsManager.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

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

    // Upload image if a new one is selected, else use the existing image URL
    String? imageUrl;
    if (_image != null) {
      imageUrl = await _uploadImageToFirebase(_image!);
    } else {
      imageUrl =
          _currentImageUrl; // Use the existing image if no new image is uploaded
    }

    String apiUrl = "http://167.71.220.5:8080/blog/update/${widget.blogId}";
    Map<String, dynamic> blogData = {
      "title": titleController.text,
      "description": descriptionController.text,
      "image": imageUrl ?? "", // Use the existing or new image URL
      "blogCategoryEnum": selectedCategory ?? "", // Add selected category
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
        Navigator.pop(context, true);
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
}

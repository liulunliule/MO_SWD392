import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/resource/color_const.dart';
import '/resource/form_field_widget.dart';
import '/resource/reponsive_utils.dart';
import '/resource/text_style.dart';
import '../layouts/second_layout.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CreateBlogScreen extends StatefulWidget {
  @override
  _CreateBlogScreenState createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final _storage = FlutterSecureStorage();

  File? _image;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SecondLayout(
      title: 'Create Blog',
      currentPage: 'create blog',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Your Blog',
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

              // Image URL input field (Optional)
              FormFieldWidget(
                controllerEditting: imageUrlController,
                labelText: 'Image URL (Optional)',
                borderColor: Colors.grey,
                forcusColor: ColorsManager.primary,
                padding: 20,
                radiusBorder: 20,
                setValueFunc: (value) {},
              ),
              SizedBox(height: 16),

              // File upload button
              Center(
                child: ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Upload Image'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: ColorsManager.primary, // Green color
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

              // Create Blog button
              Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : _createBlog,
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text('Create Blog'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                    backgroundColor: ColorsManager.primary, // Green color
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

  // Method to create a new blog
  Future<void> _createBlog() async {
    String? accessToken = await _storage.read(key: 'accessToken');

    if (accessToken == null) {
      // Handle the case when the access token is not available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Access token not available')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    String apiUrl = "http://167.71.220.5:8080/blog/create";
    String title = titleController.text;
    String description = descriptionController.text;
    String imageUrl = imageUrlController.text;

    Map<String, dynamic> blogData = {
      "title": title,
      "description": description,
      "image": imageUrl, // This could also be the URL of the uploaded image
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(blogData),
      );

      if (response.statusCode == 200) {
        // Blog created successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Blog created successfully')),
        );
        Navigator.pop(context); // Go back after creating the blog
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create blog')),
        );
      }
    } catch (e) {
      // Handle any exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating blog: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

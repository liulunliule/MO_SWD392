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

              // // Image URL input field (Optional)
              // FormFieldWidget(
              //   controllerEditting: imageUrlController,
              //   labelText: 'Image URL (Optional)',
              //   borderColor: Colors.grey,
              //   forcusColor: ColorsManager.primary,
              //   padding: 20,
              //   radiusBorder: 20,
              //   setValueFunc: (value) {},
              // ),
              // SizedBox(height: 16),

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

  // Method to create a new blog
  Future<void> _createBlog() async {
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

    // Check if an image is selected and upload it to Firebase
    String? imageUrl = imageUrlController.text;
    if (_image != null) {
      imageUrl = await _uploadImageToFirebase(_image!);
    }

    String apiUrl = "http://167.71.220.5:8080/blog/create";
    Map<String, dynamic> blogData = {
      "title": titleController.text,
      "description": descriptionController.text,
      "image": imageUrl ?? "",
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Blog created successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create blog')),
        );
      }
    } catch (e) {
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

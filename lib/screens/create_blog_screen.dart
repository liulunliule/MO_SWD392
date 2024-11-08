import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  File? _image;
  bool isLoading = false;

  List<String> categories = [];
  String? selectedCategory;
  Map<String, bool> selectedFields = {};

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http
          .get(Uri.parse("http://167.71.220.5:8080/blog/category/get-all"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['code'] == 200) {
          setState(() {
            categories = List<String>.from(data['data']);
            for (var category in categories) {
              selectedFields[category] = false;
            }
          });
        }
      } else {
        throw Exception("Failed to load categories");
      }
    } catch (e) {
      print("Error fetching categories: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to load categories")));
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImageToFirebase(File image) async {
    try {
      String fileName = path.basename(image.path);
      Reference storageRef =
          FirebaseStorage.instance.ref().child('blog_images/$fileName');
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Image upload failed")));
      return null;
    }
  }

  Future<void> _createBlog() async {
    setState(() {
      isLoading = true;
    });

    String? accessToken = await _secureStorage.read(key: 'accessToken');
    if (accessToken == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Access token not available')));
      setState(() => isLoading = false);
      return;
    }

    String? imageUrl;
    if (_image != null) {
      imageUrl = await _uploadImageToFirebase(_image!);
      if (imageUrl == null) {
        setState(() => isLoading = false);
        return; // Exit if image upload fails
      }
    }

    Map<String, dynamic> blogData = {
      "title": titleController.text,
      "description": descriptionController.text,
      "blogCategoryEnum": selectedCategory,
      "image": imageUrl ?? "",
    };

    try {
      final response = await http.post(
        Uri.parse("http://167.71.220.5:8080/blog/create"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(blogData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Blog created successfully')));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to create blog')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error creating blog: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

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
              Text("Select Category",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFields.updateAll((key, value) => false);
                        selectedFields[category] = true;
                        selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: selectedFields[category] ?? false
                            ? Color(0xFFB5ED3D)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: selectedFields[category] ?? false
                                ? Colors.green
                                : Colors.grey),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                            color: selectedFields[category] ?? false
                                ? Colors.black
                                : Colors.grey),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Upload Image'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: ColorsManager.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
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
              Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : _createBlog,
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Create Blog'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
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
}

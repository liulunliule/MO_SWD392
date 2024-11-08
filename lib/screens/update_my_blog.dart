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
  final int blogId;

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
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.wait([fetchBlogDetails(), _fetchCategories()]);
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
            selectedFields = {for (var category in categories) category: false};
          });
        }
      }
    } catch (e) {
      _showSnackbar('Error fetching categories: $e');
    }
  }

  Future<void> fetchBlogDetails() async {
    final accessToken = await _storage.read(key: 'accessToken');
    final url = "http://167.71.220.5:8080/blog/view/${widget.blogId}";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final blogData = jsonDecode(response.body)['data'];
        setState(() {
          titleController.text = blogData['title'];
          descriptionController.text = blogData['description'];
          _currentImageUrl = blogData['image'];
          selectedCategory = blogData['category'];
          if (selectedCategory != null) {
            selectedFields[selectedCategory!] = true;
          }
        });
      } else {
        _showSnackbar('Failed to fetch blog details');
      }
    } catch (e) {
      _showSnackbar('Error fetching blog details: $e');
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
              Text('Update Your Blog',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
              if (_currentImageUrl != null && _image == null)
                _buildImagePreview(_currentImageUrl!),
              _buildCategorySelection(),
              _buildUploadButton(),
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
                  onPressed: isLoading ? null : _updateBlog,
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Update Blog'),
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

  Widget _buildImagePreview(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl,
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(),
        ),
      ),
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: selectedFields[category] ?? false
                      ? Color(0xFFB5ED3D)
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
      ],
    );
  }

  Widget _buildUploadButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _pickImage,
        child: Text('Upload New Image (Optional)'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: ColorsManager.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
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
      final fileName = path.basename(image.path);
      final storageRef =
          FirebaseStorage.instance.ref().child('blog_images/$fileName');
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> _updateBlog() async {
    final accessToken = await _storage.read(key: 'accessToken');

    if (accessToken == null) {
      _showSnackbar('Access token not available');
      return;
    }

    setState(() {
      isLoading = true;
    });

    String? imageUrl;
    if (_image != null) {
      imageUrl = await _uploadImageToFirebase(_image!);
    } else {
      imageUrl = _currentImageUrl;
    }

    final apiUrl = "http://167.71.220.5:8080/blog/update/${widget.blogId}";
    final blogData = {
      "title": titleController.text,
      "description": descriptionController.text,
      "image": imageUrl ?? "",
      "blogCategoryEnum": selectedCategory ?? "",
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
        _showSnackbar('Blog updated successfully');
        Navigator.pop(context, true);
      } else {
        _showSnackbar('Failed to update blog');
      }
    } catch (e) {
      _showSnackbar('Error updating blog: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

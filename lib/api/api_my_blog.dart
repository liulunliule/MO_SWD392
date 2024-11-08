import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiMyBlog {
  static const String baseUrl = "http://167.71.220.5:8080/blog";
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Fetch all blogs created by the user
  Future<List<Map<String, dynamic>>> fetchMyBlogs() async {
    final url = "$baseUrl/view/by-account";
    List<Map<String, dynamic>> blogs = [];

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
        blogs = List<Map<String, dynamic>>.from(data);
      } else {
        print('Failed to load blogs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching blogs: $e');
    }

    return blogs;
  }

  // Delete a blog by ID
  Future<bool> deleteBlog(String blogId) async {
    final url = "$baseUrl/delete/$blogId";
    try {
      String? accessToken = await _storage.read(key: 'accessToken');
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      return response.statusCode == 202 || response.statusCode == 200;
    } catch (e) {
      print('Error occurred while deleting blog: $e');
      return false;
    }
  }

  // Update a blog
  Future<bool> updateBlog(int blogId, String title, String description,
      String imageUrl, String? category) async {
    final url = "$baseUrl/update/$blogId";
    try {
      String? accessToken = await _storage.read(key: 'accessToken');
      Map<String, dynamic> blogData = {
        "title": title,
        "description": description,
        "image": imageUrl,
        "blogCategoryEnum": category ?? "",
      };

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(blogData),
      );

      return response.statusCode == 200; // Return true if successful
    } catch (e) {
      print('Error occurred while updating blog: $e');
      return false;
    }
  }

  // Create a blog
  Future<bool> createBlog({
    required String title,
    required String description,
    required String? category,
    required String imageUrl,
  }) async {
    final url = "$baseUrl/create";
    try {
      String? accessToken = await _storage.read(key: 'accessToken');
      Map<String, dynamic> blogData = {
        "title": title,
        "description": description,
        "blogCategoryEnum": category,
        "image": imageUrl,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(blogData),
      );

      return response.statusCode == 200; // Return true if successful
    } catch (e) {
      print('Error occurred while creating blog: $e');
      return false;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiBlog {
  static const String baseUrl = "http://167.71.220.5:8080";
  static const String viewUrl = "$baseUrl/blog/view/all";
  static const String viewDetailUrl = "$baseUrl/blog/view";
  static const String createCommentUrl = "$baseUrl/comment/create";
  static const String deleteCommentUrl = "$baseUrl/comment/delete";
  static const String updateCommentUrl = "$baseUrl/comment/update";

  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Fetch all blogs
  static Future<List<Map<String, dynamic>>> fetchBlogs() async {
    try {
      final response = await http.get(Uri.parse(viewUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        return List<Map<String, dynamic>>.from(data)
            .where((blog) => blog['isDeleted'] == false)
            .toList();
      } else {
        print('Failed to load blogs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return [];
  }

  // Fetch blog detail
  static Future<Map<String, dynamic>?> fetchBlogDetail(int blogId) async {
    try {
      final response = await http.get(Uri.parse('$viewDetailUrl/$blogId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        print('Failed to load blog detail: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return null;
  }

  // Post comment
  static Future<void> postComment(int blogId, String commentText) async {
    String? accessToken = await _storage.read(key: 'accessToken');
    if (accessToken == null) {
      print('Access token not found');
      return;
    }

    final body = jsonEncode({"blogId": blogId, "comment": commentText});

    try {
      final response = await http.post(
        Uri.parse(createCommentUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );

      if (response.statusCode != 200) {
        print('Failed to post comment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while posting comment: $e');
    }
  }

  // Delete comment
  static Future<void> deleteComment(int commentId) async {
    String? accessToken = await _storage.read(key: 'accessToken');
    if (accessToken == null) {
      print('Access token not found');
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('$deleteCommentUrl/$commentId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode != 200) {
        print('Failed to delete comment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while deleting comment: $e');
    }
  }

  // Edit comment
  static Future<void> editComment(int commentId, String newCommentText) async {
    String? accessToken = await _storage.read(key: 'accessToken');
    if (accessToken == null) {
      print('Access token not found');
      return;
    }

    final body = jsonEncode({"comment": newCommentText});

    try {
      final response = await http.put(
        Uri.parse('$updateCommentUrl/$commentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );

      if (response.statusCode != 200) {
        print('Failed to update comment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while updating comment: $e');
    }
  }
}

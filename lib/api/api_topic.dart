import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiTopic {
  static const String baseUrl = "http://167.71.220.5:8080";
  static const String viewUrl = "$baseUrl/topic/view";
  static const String createUrl = "$baseUrl/topic/create";
  static const String myTopicsUrl = "$baseUrl/topic/view/by-account";
  static const String updateTopicUrl = "$baseUrl/topic/update";
  static const String deleteTopicUrl = "$baseUrl/topic/delete";

  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Fetch all topics
  static Future<List<Map<String, dynamic>>> fetchTopics() async {
    try {
      final response = await http.get(Uri.parse(viewUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data)
            .where((topic) =>
                topic['isDeleted'] == false &&
                topic['semester']['isCurrentSemester'] == true)
            .toList();
      } else {
        print('Failed to load topics: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return [];
  }

  // Fetch my topics
  static Future<List<Map<String, dynamic>>> fetchMyTopics() async {
    try {
      String? accessToken = await _storage.read(key: 'accessToken');
      final response = await http.get(
        Uri.parse(myTopicsUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> topicsData = jsonResponse['data'];
        return List<Map<String, dynamic>>.from(topicsData);
      } else {
        print('Failed to load my topics: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return [];
  }

  // Create new topic
  static Future<bool> createTopic({
    required String topicName,
    required String description,
  }) async {
    try {
      String? accessToken = await _storage.read(key: 'accessToken');
      final response = await http.post(
        Uri.parse(createUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'topicName': topicName,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to create topic: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return false;
  }

  // Update topic
  static Future<bool> updateTopic({
    required int topicId,
    required String topicName,
    required String description,
  }) async {
    try {
      String? accessToken = await _storage.read(key: 'accessToken');
      final response = await http.put(
        Uri.parse('$updateTopicUrl/$topicId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'topicName': topicName,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update topic: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return false;
  }

  // Delete topic
  static Future<bool> deleteTopic(int topicId) async {
    try {
      String? accessToken = await _storage.read(key: 'accessToken');
      final response = await http.delete(
        Uri.parse('$deleteTopicUrl/$topicId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete topic: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return false;
  }
}

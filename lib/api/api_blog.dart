import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchBlogs() async {
  final url = "http://167.71.220.5:8080/blog/view/all";
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data)
          .where((blog) => blog['isDeleted'] == false)
          .toList();
    } else {
      print('Failed to load blogs: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error occurred: $e');
    return [];
  }
}

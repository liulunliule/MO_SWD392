import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiSearchMentor {
  // Fetch mentors based on search parameters
  Future<List<Map<String, dynamic>>> fetchMentors({
    required String searchQuery,
    required String minPrice,
    required String maxPrice,
    required String selectedSpecialization,
    required String sort,
  }) async {
    final response = await http.get(Uri.parse(
        'http://167.71.220.5:8080/account/search-mentor?name=$searchQuery&minPrice=$minPrice&maxPrice=$maxPrice&specializations=$selectedSpecialization&sort=service.price&sort=$sort'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load mentors');
    }
  }

  // Fetch all specializations
  Future<List<String>> fetchSpecializations() async {
    final response = await http.get(
        Uri.parse('http://167.71.220.5:8080/account/specialization/get-all'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['code'] == 200) {
        return List<String>.from(data['data']);
      } else {
        throw Exception('Failed to load specializations');
      }
    } else {
      throw Exception('Failed to load specializations');
    }
  }
}

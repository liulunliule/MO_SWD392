import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../layouts/sticky_layout.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List to store API users
  List<Map<String, dynamic>> users = [];

  // List of schedule events (remains unchanged)
  List<Map<String, String>> schedule = [
    {'date': '23/09', 'title': 'No schedule', 'description': '', 'time': ''},
    {'date': '24/09', 'title': 'No schedule', 'description': '', 'time': ''},
    {
      'date': '25/09',
      'title': 'Meet a mentor',
      'description': 'Discussion',
      'time': '7:00-9:00pm'
    },
    {'date': '26/09', 'title': 'No schedule', 'description': '', 'time': ''},
  ];

  // Loading state to show a progress indicator while fetching data
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMentors(); // Fetch the mentors on initialization
  }

  // Fetch the mentors from the API
  Future<void> fetchMentors() async {
    final url =
        "http://167.71.220.5:8080/account/search-mentor?minPrice=0&sort=service.price&sort=asc";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          users = List<Map<String, dynamic>>.from(data['data']);
          isLoading = false; // Data loaded
        });
      } else {
        print('Failed to load mentors: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return StickyLayout(
      title: 'Home',
      currentPage: 'home',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reschedule
              Text(
                'Reschedule',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // List of users
              Container(
                height: screenHeight *
                    0.15, // Responsive height based on screen size
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          var user = users[index];
                          String avatarUrl = user['avatar'] ?? '';
                          String userName = user['accountName'] ?? 'Unknown';
                          String avatarLetter = userName[0].toUpperCase();

                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: screenWidth *
                                      0.08, // Responsive avatar size
                                  backgroundColor:
                                      avatarUrl.isEmpty ? Colors.lime : null,
                                  backgroundImage: avatarUrl.isNotEmpty
                                      ? NetworkImage(avatarUrl)
                                      : null,
                                  child: avatarUrl.isEmpty
                                      ? Text(
                                          avatarLetter,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: screenWidth * 0.05),
                                        )
                                      : null,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  userName,
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.04),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              SizedBox(height: 20),
              // Schedule
              Text(
                'Schedule',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // List of events
              Container(
                height: screenHeight *
                    0.45, // Responsive height for the schedule list
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    final event = schedule[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        clipBehavior: Clip.hardEdge,
                        elevation: 3,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date
                            Container(
                              width: screenWidth * 0.2,
                              height: screenHeight * 0.05,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                event['date']!,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                            ),
                            // Info
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event['title']!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.045,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      event['description']!.isNotEmpty
                                          ? event['description']!
                                          : 'No description',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: screenWidth * 0.035,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      event['time']!.isNotEmpty
                                          ? event['time']!
                                          : '',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: screenWidth * 0.035,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

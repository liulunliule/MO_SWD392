import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import Font Awesome
import '../layouts/second_layout.dart';

class MentorProfileScreen extends StatefulWidget {
  final int accountId;

  MentorProfileScreen({required this.accountId});

  @override
  _MentorProfileScreenState createState() => _MentorProfileScreenState();
}

class _MentorProfileScreenState extends State<MentorProfileScreen> {
  Map<String, dynamic>? mentorData;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchMentorProfile();
  }

  Future<void> fetchMentorProfile() async {
    final String apiUrl =
        "http://167.71.220.5:8080/account/profile/${widget.accountId}";
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['code'] == 200) {
          setState(() {
            mentorData = data['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            hasError = true;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Hiển thị thông báo nếu không thể mở liên kết
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open link: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SecondLayout(
      title: 'Mentor Profile',
      currentPage: 'profile',
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text("Error loading mentor profile"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: 200,
                            clipBehavior: Clip.hardEdge,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -50,
                                  left: -50,
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.green[700],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -20,
                                  right: -20,
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.green[700],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 95),
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          mentorData!['avatar'],
                                        ),
                                        radius: 90,
                                      ),

                                      // Text(
                                      //   mentorData!['name'] ?? 'No Name',
                                      //   style: TextStyle(
                                      //     color: Colors.white,
                                      //     fontSize: 24,
                                      //     fontWeight: FontWeight.bold,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // CircleAvatar(
                            //   backgroundImage: NetworkImage(
                            //     mentorData!['avatar'],
                            //   ),
                            //   radius: 50,
                            // ),
                            SizedBox(height: 10),
                            Text(
                              mentorData!['name'] ?? 'No Name',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        // Mentor Info
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                                'Email', mentorData!['email'] ?? 'No Email'),
                            _buildInfoRow(
                                'Phone', mentorData!['phone'] ?? 'No Phone'),
                            _buildInfoRow(
                                'Gender', mentorData!['gender'] ?? 'No Gender'),
                            _buildInfoRow(
                                'Date of Birth',
                                mentorData!['dayOfBirth']?.substring(0, 10) ??
                                    'No Date'),
                            _buildInfoRow(
                                'Specializations',
                                mentorData!['specializations'].join(", ") ??
                                    'No Specializations'),
                            _buildInfoRow(
                                'Role', mentorData!['role'] ?? 'No Role'),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Social Media Links
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.linkedin),
                              onPressed: () {
                                if (mentorData!['linkedinLink'] != null &&
                                    mentorData!['linkedinLink'].isNotEmpty) {
                                  _launchURL(mentorData!['linkedinLink']);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('No LinkedIn link available')),
                                  );
                                }
                              },
                            ),
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.twitter),
                              onPressed: () {
                                if (mentorData!['twitterLink'] != null &&
                                    mentorData!['twitterLink'].isNotEmpty) {
                                  _launchURL(mentorData!['twitterLink']);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('No Twitter link available')),
                                  );
                                }
                              },
                            ),
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.facebook),
                              onPressed: () {
                                if (mentorData!['facebookLink'] != null &&
                                    mentorData!['facebookLink'].isNotEmpty) {
                                  _launchURL(mentorData!['facebookLink']);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('No Facebook link available')),
                                  );
                                }
                              },
                            ),
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.youtube),
                              onPressed: () {
                                if (mentorData!['youtubeLink'] != null &&
                                    mentorData!['youtubeLink'].isNotEmpty) {
                                  _launchURL(mentorData!['youtubeLink']);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('No YouTube link available')),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

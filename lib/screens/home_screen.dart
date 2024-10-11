import 'package:flutter/material.dart';
import '../layouts/sticky_layout.dart';

class HomeScreen extends StatelessWidget {
  List<Map<String, String>> users = [
    {
      'name': 'Thuy Lieu',
      'avatar':
          'https://img.freepik.com/free-vector/cute-girl-sitting-drinking-milk-cartoon-character-hand-draw-art-illustration_56104-2279.jpg?t=st=1728667081~exp=1728670681~hmac=dd670b3fae49b742d9e48300e452f1994631771fcf348572517b1ed5cfa325cb&w=740'
    },
    {
      'name': 'Van Vinh',
      'avatar':
          'https://img.freepik.com/free-vector/cute-man-drinking-coffee-cartoon-vector-icon-illustration-people-drink-icon-concept-isolated-flat_138676-8425.jpg?t=st=1728666973~exp=1728670573~hmac=4672e68ac77a88095fa2b3497b436545d90deacbdf33f691b5555091e27f5503&w=740'
    },
    {
      'name': 'Nhat Huy',
      'avatar':
          'https://img.freepik.com/free-vector/cute-cool-boy-dabbing-pose-cartoon-vector-icon-illustration-people-fashion-icon-concept-isolated_138676-5680.jpg?t=st=1728666743~exp=1728670343~hmac=fb79354534b7b2371dcc2a26b5deaff53c4a42331d0f38eb94576ef7c2d59303&w=740'
    },
    {
      'name': 'Minh Dung',
      'avatar':
          'https://img.freepik.com/premium-vector/cute-cartoon-character-man-smile_81698-1052.jpg?w=740'
    },
    {
      'name': 'Bao Ngoc',
      'avatar':
          'https://img.freepik.com/premium-vector/cute-girl-long-hair-with-pink-sweater-greeting-chibi-kawaii_380474-716.jpg?w=740'
    },
    {'name': 'Sungkar', 'avatar': ''},
    {'name': 'Shireen', 'avatar': ''},
    {'name': 'John', 'avatar': ''},
    {'name': 'Hannahsx', 'avatar': ''},
    {'name': 'Leahaed', 'avatar': ''},
  ];

  List<Map<String, String>> schedule = [
    {'date': '23/09', 'title': 'No schedule', 'description': '', 'time': ''},
    {'date': '24/09', 'title': 'No schedule', 'description': '', 'time': ''},
    {
      'date': '25/09',
      'title': 'Meet a mentor',
      'description': 'Discussion',
      'time': '7:00-9:00pm'
    },
    {'date': '26/09', 'title': 'No schedule', 'description': '', 'time': ''}
  ];

  @override
  Widget build(BuildContext context) {
    return StickyLayout(
      title: 'Home',
      currentPage: 'home',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //reschedule
            Text(
              'Reschedule',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            //List
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var user = users[index];
                  String avatarUrl = user['avatar'] ?? ''; // Lấy URL avatar
                  String userName = user['name']!;
                  String avatarLetter =
                      userName[0].toUpperCase(); // Lấy chữ cái đầu

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              avatarUrl.isEmpty ? Colors.lime : null,
                          backgroundImage: avatarUrl.isNotEmpty
                              ? NetworkImage(avatarUrl)
                              : null, // Nếu có avatar URL thì dùng, nếu không thì để null
                          child: avatarUrl.isEmpty
                              ? Text(avatarLetter,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20)) // Hiện chữ cái đầu
                              : null, // Không hiện gì nếu có hình ảnh
                        ),
                        SizedBox(height: 5),
                        Text(userName, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            //Schedule
            Text(
              'Schedule',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            //List
            Container(
              height: 380, // Fixed height
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
                        crossAxisAlignment: CrossAxisAlignment.start, // Align the date to the top
                        children: [
                          // Date
                          Container(
                            width: 80,
                            height: 30,
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
                                fontSize: 16,
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
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  // Hiển thị mô tả nếu có
                                  Text(
                                    event['description']!.isNotEmpty
                                        ? event['description']!
                                        : 'No description',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  // Hiển thị thời gian nếu có
                                  Text(
                                    event['time']!.isNotEmpty ? event['time']! : '',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 14,
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
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import '../layouts/second_layout.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late Map<DateTime, List<String>> _events;
  late List<String> _selectedEvents;
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  final _storage = FlutterSecureStorage();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _events = {};
    _selectedEvents = [];
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() {
      _isLoading = true;
    });

    // Lấy accessToken và role từ FlutterSecureStorage
    String? accessToken = await _storage.read(key: 'accessToken');
    String? userRole = await _storage.read(key: 'role');

    // Xác định URL API dựa trên role
    String apiUrl = "";
    if (userRole == 'MENTOR') {
      apiUrl = "http://167.71.220.5:8080/mentor/booking/view-upcoming";
    } else if (userRole == 'STUDENT') {
      apiUrl = "http://167.71.220.5:8080/booking/student/view-upcoming";
    } else {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Thực hiện gọi API
    if (accessToken != null && apiUrl.isNotEmpty) {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['code'] == 200) {
          final List<dynamic> bookings = data['data'];
          Map<DateTime, List<String>> events = {};

          for (var booking in bookings) {
            try {
              DateTime bookingDate = DateTime.parse(booking['bookingDate']);
              DateTime normalizedDate = DateTime(
                  bookingDate.year, bookingDate.month, bookingDate.day);

              String mentorName;
              String location;
              String note;
              String startTime;
              String endTime;
              String status;

              if (userRole == 'MENTOR') {
                mentorName = booking['mentor']['mentorName'];
                location = booking['location'] ?? 'No location';
                note = booking['note'] ?? 'No note';
                startTime = booking['startTime'];
                endTime = booking['endTime'];
                status = booking['status'] ?? 'No status';
              } else {
                mentorName = booking['mentorName'];
                location = booking['location'] ?? 'No location';
                note = booking['locationNote'] ?? 'No note';
                startTime = booking['startTime'];
                endTime = booking['endTime'];
                status = booking['bookingStatus'];
              }

              DateTime start = DateTime.parse('2024-11-12 ' + startTime);
              DateTime end = DateTime.parse('2024-11-12 ' + endTime);
              String formattedStartTime =
                  "${start.hour}:${start.minute.toString().padLeft(2, '0')}";
              String formattedEndTime =
                  "${end.hour}:${end.minute.toString().padLeft(2, '0')}";

              String eventDescription = '''
              Mentor: $mentorName
              Location: $location
              Note: $note
              Time: $formattedStartTime - $formattedEndTime
              Status: $status
            ''';

              if (events[normalizedDate] == null) {
                events[normalizedDate] = [];
              }
              events[normalizedDate]?.add(eventDescription);
            } catch (e) {
              print('Error parsing booking data: $e');
            }
          }
          setState(() {
            _events = events;
            _selectedEvents = _events[_selectedDay] ?? [];
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return SecondLayout(
      title: 'Schedule',
      currentPage: 'schedule',
      body: Column(
        children: [
          Container(
            height: 420.0,
            child: CalendarCarousel(
              onDayPressed: (DateTime date, List<Event> events) {
                setState(() {
                  _selectedDay = date;
                  _selectedEvents = _getEventsForDay(date);
                });
              },
              selectedDayButtonColor: Color(0xFF4CAF50),
              selectedDayTextStyle: TextStyle(color: Colors.white),
              todayButtonColor: Colors.green,
              todayTextStyle: TextStyle(color: Colors.white),
              daysHaveCircularBorder: true,
              markedDatesMap:
                  EventList<Event>(events: _events.map((date, events) {
                return MapEntry(
                  date,
                  events
                      .map((event) => Event(date: date, title: event))
                      .toList(),
                );
              })),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _selectedEvents.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedEvents[index],
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                              SizedBox(height: 10),
                              // Divider(),
                              // SizedBox(height: 10),
                              // Text(
                              //   'Event Details:',
                              //   style: TextStyle(
                              //       fontSize: 14, color: Colors.grey[700]),
                              // ),
                              // SizedBox(height: 5),
                              // Row(
                              //   children: [
                              //     Icon(Icons.location_on,
                              //         color: Colors.green, size: 16),
                              //     SizedBox(width: 5),
                              //     Text('Location: ${_selectedEvents[index]}'),
                              //   ],
                              // ),
                              // Row(
                              //   children: [
                              //     Icon(Icons.schedule,
                              //         color: Colors.green, size: 16),
                              //     SizedBox(width: 5),
                              //     Text('Time: ${_selectedEvents[index]}'),
                              //   ],
                              // ),
                              // Row(
                              //   children: [
                              //     Icon(Icons.person,
                              //         color: Colors.green, size: 16),
                              //     SizedBox(width: 5),
                              //     Text('Mentor: ${_selectedEvents[index]}'),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

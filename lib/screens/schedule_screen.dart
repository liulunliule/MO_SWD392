import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
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

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _events = {
      DateTime.utc(2024, 09, 25): ['Meet a mentor'],
      DateTime.utc(2024, 10, 12): ['Meet a mentor'],
      DateTime.utc(2024, 10, 15): ['Meet a mentor'],
      DateTime.utc(2024, 10, 18): ['Meet a mentor'],
      DateTime.utc(2024, 11, 12): ['Meet a mentor'],
      DateTime.utc(2024, 11, 15): ['Meet a mentor'],
      DateTime.utc(2024, 11, 18): ['Meet a mentor'],
      DateTime.utc(2024, 12, 12): ['Meet a mentor'],
      DateTime.utc(2024, 12, 15): ['Meet a mentor'],
      DateTime.utc(2025, 01, 18): ['Meet a mentor'],
    };
    _selectedEvents = _events[_selectedDay] ?? [];
  }

  // Function to return events for the selected day
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
          // Calendar Widget
          TableCalendar(
            firstDay: DateTime.utc(2020, 01, 01),
            lastDay: DateTime.utc(2025, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedEvents = _getEventsForDay(selectedDay);
              });
            },
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.green, // Today's date highlighted in green
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green[300], // Selected day color
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(
                  color: Colors.red), // Weekend days highlighted in red
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.green),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.green),
            ),
          ),
          SizedBox(height: 20),
          // Event List
          Expanded(
            child: ListView.builder(
              itemCount: _selectedEvents.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  title: Text(
                    _selectedEvents[index],
                    style: TextStyle(fontSize: 18),
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

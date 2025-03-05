import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';


// Event model with title and designated color.
class Event {
  final String title;
  final Color color;
  Event({required this.title, required this.color});
}

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Updated events map (using DateTime as key and a list of Event objects as value)
  final Map<DateTime, List<Event>> _events = {
    DateTime(2025, 1, 1): [
      Event(
        title: 'Women International Day Celebration',
        color: const Color.fromRGBO(42, 210, 201, 1),
      ),
    ],
    DateTime(2025, 1, 10): [
      Event(
        title: 'Game Competition Day',
        color: const Color.fromRGBO(237, 46, 126, 1),
      ),
    ],
    DateTime(2025, 1, 19): [
      // Using a default color for events without a specified color.
      Event(title: 'Special Workshop', color: Colors.grey),
    ],
    DateTime(2025, 1, 25): [
      Event(
        title: 'Company Anniversary',
        color: const Color.fromRGBO(244, 183, 64, 1),
      ),
    ],
    DateTime(2025, 1, 31): [
      Event(title: 'University Conference', color: Colors.grey),
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  // Returns the list of events for a given day.
  List<Event> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  // Returns a list of (DateTime, Event) entries for the current focused month.
  List<MapEntry<DateTime, Event>> _getMonthEvents() {
    List<MapEntry<DateTime, Event>> monthEvents = [];
    _events.forEach((date, events) {
      if (date.year == _focusedDay.year && date.month == _focusedDay.month) {
        for (final event in events) {
          monthEvents.add(MapEntry(date, event));
        }
      }
    });
    // Sort events by date
    monthEvents.sort((a, b) => a.key.compareTo(b.key));
    return monthEvents;
  }

  // Helper to get month name from its number.
  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final monthName = _getMonthName(_focusedDay.month);
    final monthEvents = _getMonthEvents();

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFC),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0), // Set the height to your desired value
            child: AppBar(
              automaticallyImplyLeading: false, // Disable the back arrow
              backgroundColor: Colors.white,           // White background
              elevation: 0,                             // Remove default shadow
              title: const Text(
                'UPM Community',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,          // Bold text
                  fontSize: 18,                         // Font size 18
                  color: Color(0xFF7A1DFF),             // Color #7A1DFF
                ),
              ),
              centerTitle: true,                        // Center the title
              shadowColor: const Color(0x1A1B1D36),     // Shadow color with 10% opacity
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(0),
                ),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1A1B1D36),          // Shadow color with 10% opacity
                      offset: Offset(0, 4),              // Position: y = 4
                      blurRadius: 20,                    // Blur radius: 20
                    ),
                  ],
                ),
              ),
            ),
          ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            

            /// Calendar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                // Loads the events for each day.
                eventLoader: _getEventsForDay,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Remove the default blue “today” circle and marker dots.
                calendarStyle: CalendarStyle(
                  todayDecoration:
                      const BoxDecoration(color: Colors.transparent),
                  markerDecoration:
                      const BoxDecoration(color: Colors.transparent),
                ),
                // Use calendarBuilders to customize the day cell appearance.
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, date, focusedDay) {
                    final events = _getEventsForDay(date);
                    if (events.isNotEmpty) {
                      // Use the color of the first event for the whole cell.
                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: events.first.color,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${date.day}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return null; // Use default rendering for dates without events.
                  },
                  selectedBuilder: (context, date, focusedDay) {
                    final events = _getEventsForDay(date);
                    if (events.isNotEmpty) {
                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: events.first.color,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${date.day}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromRGBO(122, 29, 255, 1),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${date.day}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                  todayBuilder: (context, date, focusedDay) {
                    final events = _getEventsForDay(date);
                    if (events.isNotEmpty) {
                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: events.first.color,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${date.day}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    // For "today" without an event, we remove the blue circle.
                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${date.day}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// Events List Title (Dynamic Month Name)
            Text(
              '$monthName Events',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            /// Dynamic Event List for the Month
            Expanded(
              child: ListView(
                children: monthEvents.map((entry) {
                  final date = entry.key;
                  final event = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Colored circle matching the event color.
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: event.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              // Dynamically formatted date.
                              Text(
                                DateFormat('d MMM yyyy').format(date),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          '10:00 AM', // Dummy time (adjust as needed)
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

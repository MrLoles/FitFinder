import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWeek extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime currentWeekStart = now.subtract(Duration(days: now.weekday - 1));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TableCalendar(
        locale: "pl_PL",
        calendarFormat: CalendarFormat.week,
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerVisible: false,
        focusedDay: DateTime.now(),
        firstDay: currentWeekStart,
        lastDay: currentWeekStart.add(Duration(days: 6)),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
          weekendTextStyle: TextStyle(color: Colors.blue)
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.black87),
          weekendStyle: TextStyle(color: Colors.black87),
        ),
      ),
    );
  }

  static String getDayOfWeek(int dayIndex) {
    DateTime date = DateTime.now().subtract(Duration(days: DateTime.now().weekday - dayIndex));
    return DateFormat('EEEE', 'pl').format(date);
  }

  static int dayOfWeekFromString(String day) {
    Map<String, int> days = {
      'Poniedziałek': 1,
      'Wtorek': 2,
      'Środa': 3,
      'Czwartek': 4,
      'Piątek': 5,
      'Sobota': 6,
      'Niedziela': 7,
    };
    return days[day.toLowerCase()] ?? 0;
  }
}

class MyDropdownWidget extends StatefulWidget {
  String selectedDay = 'Poniedziałek';

  @override
  _MyDropdownWidgetState createState() => _MyDropdownWidgetState();
}

class _MyDropdownWidgetState extends State<MyDropdownWidget> {

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.selectedDay,
      onChanged: (newValue) {
        setState(() {
          widget.selectedDay = newValue!;
        });
      },
      items: <String>[
        'Poniedziałek',
        'Wtorek',
        'Środa',
        'Czwartek',
        'Piątek',
        'Sobota',
        'Niedziela',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: Theme.of(context).textTheme.bodyLarge,),
        );
      }).toList(),
    );
  }
}
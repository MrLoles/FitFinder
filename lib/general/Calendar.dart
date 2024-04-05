import 'package:flutter/material.dart';
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
}
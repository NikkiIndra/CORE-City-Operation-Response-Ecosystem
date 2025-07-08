import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ModernCalendar extends StatelessWidget {
  const ModernCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kalender"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TableCalendar(
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          focusedDay: today,
          currentDay: today,
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            leftChevronIcon: Icon(Icons.chevron_left_rounded, size: 28),
            rightChevronIcon: Icon(Icons.chevron_right_rounded, size: 28),
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: TextStyle(
              color: isDark ? Colors.red[300] : Colors.red,
              fontWeight: FontWeight.bold,
            ),
            weekdayStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
          calendarStyle: CalendarStyle(
            defaultTextStyle: const TextStyle(fontSize: 14),
            weekendTextStyle: TextStyle(
              color: isDark ? Colors.red[300] : Colors.red,
            ),
            todayDecoration: BoxDecoration(
              color: primaryColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            outsideDaysVisible: false,
          ),
        ),
      ),
    );
  }
}

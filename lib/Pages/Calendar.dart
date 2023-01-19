import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:papprototype/Pages/event_editing_page.dart';
import 'package:papprototype/provider/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../model/event_data_source.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: SfCalendar(
                dataSource: EventDataSource(events),
                view: CalendarView.month,
              ),
            ),
            FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Colors.red,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => EventEditingPage()))),
            )
          ],
        ),
      ),
    );
  }
}

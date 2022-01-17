import 'package:calendar_app/screens/edit_event.dart';
import 'package:calendar_app/widgets/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as googleAPI;

class HomePage extends StatelessWidget {
  googleAPI.Event event = googleAPI.Event(
    summary: '',
    description: '',
    start: googleAPI.EventDateTime(
      dateTime: DateTime.now(),
    ),
    end: googleAPI.EventDateTime(
      dateTime: DateTime.now().add(
        const Duration(
          hours: 2,
        ),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar App'),
        centerTitle: true,
      ),
      body: const CalendarWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditEventPage(
              event: null,
            ),
          ),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

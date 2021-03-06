import 'package:calendar_app/models/google_event_data_source.dart';
import 'package:calendar_app/providers/event_provider.dart';
import 'package:calendar_app/screens/view_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:googleapis/calendar/v3.dart' as googleAPI;

class TasksWidget extends StatefulWidget {
  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context, listen: false);
    final selectedEvents = provider.eventsOfSelectedDate;

    if (selectedEvents.isEmpty) {
      return const Center(
        child: const Text(
          'No Events Found!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      );
    }
    return SfCalendarTheme(
      data: SfCalendarThemeData(
        viewHeaderBackgroundColor: Colors.red,
        // headerBackgroundColor: Colors.blue,
        // backgroundColor: Colors.white,
      ),
      child: SfCalendar(
        view: CalendarView.timelineDay,
        timeSlotViewSettings: const TimeSlotViewSettings(
          timeInterval: Duration(hours: 1),
          timeTextStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        dataSource: GoogleEventDataSource(events: provider.events),
        initialDisplayDate: provider.selectedDate,
        appointmentBuilder: appointmentBuilder,
        headerHeight: 0,
        todayHighlightColor: Colors.black,
        selectionDecoration: BoxDecoration(
          color: Colors.red.withOpacity(0.3),
        ),
        onTap: (details) {
          if (details.appointments == null) return;

          final googleAPI.Event event = details.appointments!.first;

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ViewEventPage(event: event),
            ),
          );
        },
      ),
    );
  }

  Widget appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final googleAPI.Event event = details.appointments.first;
    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.green,
        // color: event.colorId.withOpacity(0.5),
      ),
      child: Center(
        child: Text(
          event.summary!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

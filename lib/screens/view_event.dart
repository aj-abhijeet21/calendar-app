import 'package:calendar_app/providers/event_provider.dart';
import 'package:calendar_app/screens/edit_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:googleapis/calendar/v3.dart' as googleAPI;

class ViewEventPage extends StatelessWidget {
  final googleAPI.Event event;

  ViewEventPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: buildViewingActions(context, event),
      ),
      body: ListView(
        padding: const EdgeInsets.all(
          32,
        ),
        children: [
          buildDateTime(event),
          const SizedBox(
            height: 32,
          ),
          Text(
            event.summary!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            event.description ?? 'No Description',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDateTime(googleAPI.Event event) {
    return Column(
      children: [
        buildDate(
          'From',
          event.start!.dateTime!,
        ),
        buildDate(
          'To',
          event.end!.dateTime!,
        ),
      ],
    );
  }

  Widget buildDate(String title, DateTime date) {
    String formattedDate = DateFormat('dd-MMM-yyyy hh:mm a').format(date);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          formattedDate,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  List<Widget> buildViewingActions(
      BuildContext context, googleAPI.Event event) {
    return [
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => EditEventPage(event: event),
          ),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          final provider = Provider.of<EventProvider>(context, listen: false);
          provider.deleteGoogleEvent(event);
          Navigator.pop(context);
        },
      ),
    ];
  }
}

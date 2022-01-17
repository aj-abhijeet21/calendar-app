import 'package:calendar_app/models/event.dart';
import 'package:calendar_app/models/google_event_data_source.dart';
import 'package:calendar_app/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as googleAPI;

class EventProvider extends ChangeNotifier {
  // final List<Event> _eventsLocal = [];
  final List<googleAPI.Event> _events = <googleAPI.Event>[];
  late GoogleAPIClient httpClient;
  late googleAPI.CalendarApi calendarAPI;
  late googleAPI.Events calEvents;
  GoogleSignInAccount? currentUser;
  String calenderId = "primary";

  List<googleAPI.Event> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  Future<void> initCalendar(GoogleSignInAccount user) async {
    httpClient = GoogleAPIClient(await user.authHeaders);
    calendarAPI = googleAPI.CalendarApi(httpClient);
    calEvents = await calendarAPI.events.list("primary");

    if (calEvents != null && calEvents.items != null) {
      for (int i = 0; i < calEvents.items!.length; i++) {
        final googleAPI.Event event = calEvents.items![i];
        if (event.start == null) {
          continue;
        }
        _events.add(event);
      }
    }

    notifyListeners();
  }

  void setDate(DateTime date) => _selectedDate = date;

  List<googleAPI.Event> get eventsOfSelectedDate => _events;

  void refreshEvents() async {
    _events.clear();

    calEvents = await calendarAPI.events.list("primary");

    if (calEvents != null && calEvents.items != null) {
      for (int i = 0; i < calEvents.items!.length; i++) {
        final googleAPI.Event event = calEvents.items![i];
        if (event.start == null) {
          continue;
        }
        _events.add(event);
      }
    }

    notifyListeners();
  }

  void addGoogleEvent(googleAPI.Event event) async {
    googleAPI.Event eventRequest =
        await calendarAPI.events.insert(event, "primary");
    _events.add(eventRequest);
    refreshEvents();
    notifyListeners();
  }

  void deleteGoogleEvent(googleAPI.Event event) async {
    await calendarAPI.events.delete("primary", event.id!);
    Event eventRequest = mapGoogleEventToLocal(event);
    _events.remove(event);
    refreshEvents();
    notifyListeners();
  }

  void editGoogleEvent(
      googleAPI.Event newEvent, googleAPI.Event oldEvent) async {
    googleAPI.Event eventRequest = googleAPI.Event(
      summary: newEvent.summary,
      description: 'Description',
      start: newEvent.start,
      end: newEvent.end,
      endTimeUnspecified: newEvent.endTimeUnspecified,
    );
    await calendarAPI.events.patch(eventRequest, "primary", oldEvent.id!);
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;
    refreshEvents();
    notifyListeners();
  }

  void setCurrentUser(GoogleSignInAccount user) {
    currentUser = user;

    notifyListeners();
  }

  void signOut() {
    googleSignIn.disconnect();
  }

  Event mapGoogleEventToLocal(googleAPI.Event event) {
    return Event(
      title: event.summary!,
      description: 'Description',
      from: event.start!.dateTime!,
      to: event.end!.dateTime!,
      isAllDay: event.endTimeUnspecified!,
    );
  }

  googleAPI.Event mapLocalToGoogleEvent(Event event) {
    return googleAPI.Event(
      summary: event.title,
      description: 'Description',
      start: googleAPI.EventDateTime(
        dateTime: event.from,
      ),
      end: googleAPI.EventDateTime(
        dateTime: event.to,
      ),
      endTimeUnspecified: event.isAllDay,
    );
  }
}

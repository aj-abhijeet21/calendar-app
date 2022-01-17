import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:googleapis/calendar/v3.dart' as googleAPI;

class GoogleEventDataSource extends CalendarDataSource {
  GoogleEventDataSource({
    required List<googleAPI.Event> events,
  }) {
    this.appointments = events;
  }

  googleAPI.Event getEvent(int index) =>
      appointments![index] as googleAPI.Event;

  @override
  DateTime getStartTime(int index) {
    final googleAPI.Event event = getEvent(index);
    return event.start!.date ?? event.start!.dateTime!.toLocal();
  }

  @override
  DateTime getEndTime(int index) {
    final googleAPI.Event event = getEvent(index);
    if (event.endTimeUnspecified != null && event.endTimeUnspecified == true) {
      return (event.start!.date ?? event.start!.dateTime!.toLocal());
    } else {
      return (event.end!.date != null
          ? event.end!.date!.add(
              const Duration(
                days: -1,
              ),
            )
          : event.end!.dateTime!.toLocal());
    }
  }

  @override
  String getSubject(int index) {
    final googleAPI.Event event = getEvent(index);
    if (event.summary == null || event.summary!.isEmpty) {
      return 'No Title';
    } else {
      return event.summary!;
    }
  }

  @override
  // Color getColor(int index) => getEvent(index).;

  @override
  bool isAllDay(int index) => getEvent(index).start!.date != null;
}

class GoogleAPIClient extends IOClient {
  Map<String, String> _headers;

  GoogleAPIClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      super.head(url, headers: headers!..addAll(_headers));
}

import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
// ignore: library_prefixes

final GoogleSignIn googleSignIn = GoogleSignIn(
  // clientId: '700381350776-ibmu5t9ka150vgc8phr7v9rdgtev05kc.apps.googleusercontent.com',
  scopes: <String>['https://www.googleapis.com/auth/calendar'],
);

class Utils {
  static String toDateTime(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);
    return '$date $time';
  }

  static String toDate(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    return '$date';
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);
    return '$time';
  }
}

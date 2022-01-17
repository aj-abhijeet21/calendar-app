import 'package:calendar_app/providers/event_provider.dart';
import 'package:calendar_app/screens/home.dart';
import 'package:calendar_app/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:googleapis/calendar/v3.dart' as googleAPI;

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EventProvider provider =
        Provider.of<EventProvider>(context, listen: false);

    void getGoogleEventsData(GoogleSignInAccount user) async {
      provider.initCalendar(user);
    }

    Future<void> signInWithGoogle() async {
      try {
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        getGoogleEventsData(googleUser!);

        provider.setCurrentUser(googleUser);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } catch (error) {
        print(error);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar App'),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.redAccent),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              textStyle: MaterialStateProperty.all(
                TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
            ),
            child: const Text(
              'Sign in with Google',
            ),
            onPressed: signInWithGoogle,
          ),
        ),
      ),
    );
  }
}

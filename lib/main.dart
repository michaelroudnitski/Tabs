import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tabs/screens/create.dart';
import 'package:tabs/screens/home.dart';
import 'package:tabs/screens/login.dart';
import 'package:tabs/screens/register.dart';
import 'package:tabs/screens/welcome.dart';
import 'package:tabs/services/auth.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final Color primaryColor = Color(0xff03da9d);
  final Color accentColor = Color(0xff333333);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabs',
      theme: ThemeData(
        primaryColor: primaryColor,
        accentColor: accentColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(color: Colors.white),
        fontFamily: 'Rubik',
        textTheme: TextTheme(
          display1:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          display2: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          button: TextStyle(color: Colors.white),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.all(8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      routes: {
        Welcome.id: (context) => Welcome(),
        Register.id: (context) => Register(),
        Login.id: (context) => Login(),
        Create.id: (context) => Create(),
      },
      home: FutureBuilder<FirebaseUser>(
        future: Auth.getCurrentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.done) {
            if (userSnapshot.error != null) {
              print("error");
              return Text(userSnapshot.error.toString());
            }
            return userSnapshot.hasData
                ? Home(userSnapshot.data.uid)
                : Welcome();
          } else {
            return Text(
              "Tabs",
              style: Theme.of(context).textTheme.display1,
            );
          }
        },
      ),
    );
  }
}

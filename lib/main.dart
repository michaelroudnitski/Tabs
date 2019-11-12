import 'package:flutter/material.dart';
import 'package:tabs/screens/create.dart';
import 'package:tabs/screens/home.dart';
import 'package:tabs/screens/register.dart';
import 'package:tabs/screens/welcome.dart';

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
        appBarTheme: AppBarTheme(color: Colors.white),
        fontFamily: 'Rubik',
        textTheme: TextTheme(
          display1: TextStyle(
              fontFamily: 'Prata',
              color: Colors.black87,
              fontWeight: FontWeight.bold),
          display2: TextStyle(
            fontFamily: 'Rubik',
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
      initialRoute: Welcome.id,
      routes: {
        Welcome.id: (context) => Welcome(),
        Register.id: (context) => Register(),
        Home.id: (context) => Home(),
        Create.id: (context) => Create(),
      },
    );
  }
}

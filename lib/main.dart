import 'package:flutter/material.dart';
import 'package:tabs/screens/create.dart';
import 'package:tabs/screens/home.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final Color primaryColor = Color.fromARGB(0xFF, 3, 218, 157);
  final Color accentColor = Color.fromARGB(0xFF, 218, 3, 25);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabs',
      theme: ThemeData(
        primaryColor: primaryColor,
        accentColor: accentColor,
        appBarTheme: AppBarTheme(color: Colors.white),
        textTheme: TextTheme(
          display1: TextStyle(
              fontFamily: 'Prata',
              color: Colors.black87,
              fontWeight: FontWeight.bold),
          button: TextStyle(color: Colors.white),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.yellow, width: 4.0)),
        ),
      ),
      initialRoute: Home.id,
      routes: {
        Home.id: (context) => Home(),
        Create.id: (context) => Create(),
      },
    );
  }
}

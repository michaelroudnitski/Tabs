import 'package:flutter/material.dart';
import 'package:tabs/create.dart';
import 'package:tabs/home.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final Color primaryColor = Colors.yellow[400];
  final Color accentColor = Colors.lightBlueAccent;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabs',
      theme: ThemeData(
        // brightness: Brightness.dark,
        primaryColor: primaryColor,
        accentColor: accentColor,
        buttonTheme: ButtonThemeData(
          buttonColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(38.0),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(38.0),
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

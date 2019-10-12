import 'package:flutter/material.dart';
import 'package:tabs/create.dart';
import 'package:tabs/home.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabs',
      // theme: ThemeData.dark(),
      initialRoute: Home.id,
      routes: {
        Home.id: (context) => Home(),
        Create.id: (context) => Create(),
      },
    );
  }
}

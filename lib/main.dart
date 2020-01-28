import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabs/providers/settingsState.dart';
import 'package:tabs/screens/create.dart';
import 'package:tabs/screens/home.dart';
import 'package:tabs/screens/login.dart';
import 'package:tabs/screens/register.dart';
import 'package:tabs/screens/settings.dart';
import 'package:tabs/screens/welcome.dart';
import 'package:tabs/services/auth.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final Color primaryColor = Color(0xff03da9d);
  final Color accentColor = Color(0xff333333);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsState>(
      create: (context) => SettingsState(),
      child: MaterialApp(
        title: 'Tabs',
        theme: ThemeData(
          primaryColor: primaryColor,
          accentColor: accentColor,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(color: Colors.white),
          fontFamily: 'Rubik',
          textTheme: TextTheme(
            headline4:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            headline3: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            button: TextStyle(color: Colors.white),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: primaryColor,
            textTheme: ButtonTextTheme.normal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.all(8),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(style: BorderStyle.none),
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
          NewTab.id: (context) => NewTab(),
          Settings.id: (context) => Settings()
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
                style: Theme.of(context).textTheme.headline4,
              );
            }
          },
        ),
      ),
    );
  }
}

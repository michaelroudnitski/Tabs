import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabs/controllers/tabsController.dart';
import 'package:tabs/screens/create.dart';
import 'package:tabs/screens/settings.dart';
import 'package:tabs/screens/welcome.dart';
import 'package:tabs/services/auth.dart';
import 'package:tabs/tabsContainer.dart';
import 'dart:io' show Platform;

class Home extends StatelessWidget {
  static const String id = "home_screen";
  final String uid;
  Home(this.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffefefe),
      body: Stack(
        children: <Widget>[
          Container(
            height: 225,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1, 0.6],
                colors: [
                  Theme.of(context).primaryColor.withGreen(190),
                  Theme.of(context).primaryColor,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(
                    MediaQuery.of(context).size.width * 0.50, 18),
                bottomRight: Radius.elliptical(
                    MediaQuery.of(context).size.width * 0.50, 18),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 5,
            child: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _showSignOutDialog(context);
              },
            ),
          ),
          Positioned(
            top: 30,
            right: 5,
            child: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed(Settings.id);
              },
            ),
          ),
          SafeArea(
            child: MultiProvider(
              providers: [
                StreamProvider<QuerySnapshot>(
                  create: (context) => TabsController.getUsersTabs(this.uid),
                ),
              ],
              child: TabsContainer(),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool flag = await Auth.isEmailVerified();
          if (flag)
            Navigator.pushNamed(context, NewTab.id);
          else
            _showEmailConfirmDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void _showSignOutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: Text("Confirm sign out?"),
          content: Text("Your Tabs will still be here next time you sign in"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text("Sign Out"),
              onPressed: () {
                Auth.signOut();
                Navigator.pushReplacementNamed(context, Welcome.id);
              },
            ),
          ],
        );
      } else
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text("Confirm sign out?"),
          content: Text("Your Tabs will still be here next time you sign in"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              textColor: Colors.black87,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Sign Out"),
              textColor: Colors.red,
              onPressed: () {
                Auth.signOut();
                Navigator.pushReplacementNamed(context, Welcome.id);
              },
            ),
          ],
        );
    },
  );
}

void _showEmailConfirmDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: Text("Sorry, you need to verify your email first"),
          content: Text("Please check your email"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text("Resend Email"),
              onPressed: () {
                Auth.sendEmailVerification();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      } else
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text("Sorry, you need to verify your email first"),
          content: Text("Please check your email"),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              textColor: Colors.black87,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Resend Email"),
              textColor: Colors.black87,
              onPressed: () {
                Auth.sendEmailVerification();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
    },
  );
}

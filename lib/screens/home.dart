import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabs/controllers/tabsController.dart';
import 'package:tabs/screens/create.dart';
import 'package:tabs/services/auth.dart';
import 'package:tabs/tabsList.dart';

class Home extends StatelessWidget {
  static const String id = "home_screen";
  final FirebaseUser user;
  Home(user) : user = user ?? Auth.getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(
                    MediaQuery.of(context).size.width * 0.50, 18),
                bottomRight: Radius.elliptical(
                    MediaQuery.of(context).size.width * 0.50, 18),
              ),
            ),
          ),
          SafeArea(
            child: StreamProvider(
              builder: (context) => TabsController.getUsersTabs(this.user.uid),
              child: TabsList(),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Create.id);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabs/providers/settingsState.dart';
import 'package:tabs/widgets/confirmDialog.dart';
import 'package:tabs/services/auth.dart';
import 'package:tabs/screens/welcome.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = "/settings";

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  final currencies = SettingsState.currencies;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Settings"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  "Currency",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Wrap(
                spacing: 8,
                children: List<Widget>.generate(
                  currencies.length,
                  (int index) {
                    return ChoiceChip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      label: Text(currencies[index]),
                      selected: currencies[index] ==
                          Provider.of<SettingsState>(context).selectedCurrency,
                      onSelected: (bool selected) {
                        if (selected)
                          Provider.of<SettingsState>(context, listen: false)
                              .selectCurrency(currencies[index]);
                      },
                    );
                  },
                ).toList(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 10),
                child: Text(
                  "Account",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              FutureBuilder(
                future: Auth.getCurrentUser(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<User> snapshot,
                ) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Signed in as",
                            style: Theme.of(context).textTheme.subtitle2),

                        Text(snapshot.data.email,
                            style: Theme.of(context).textTheme.subtitle1),
                        if (!snapshot.data.emailVerified)
                          Text(
                            "Account pending email verification",
                            style: TextStyle(color: Colors.orange),
                          ),
                      ],
                    );
                  } else {
                    return Text("Loading...");
                  }
                },
              ),
              OutlineButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => new ConfirmDialog(
                    title: "Sign out?",
                    content:
                        "Your tabs will still be here next time you sign in",
                    confirmText: "Sign Out",
                    confirm: () {
                      Navigator.of(context).pop(true);
                      Auth.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, Welcome.id, (_) => false);
                    },
                  ),
                ),
                child: Text("Sign Out"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

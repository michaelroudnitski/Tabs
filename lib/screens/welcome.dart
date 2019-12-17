import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:tabs/screens/home.dart';
import 'package:tabs/screens/login.dart';
import 'package:tabs/services/auth.dart';
import './register.dart';

class Welcome extends StatelessWidget {
  static const String id = "welcome";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    "Tabs",
                    style: Theme.of(context)
                        .textTheme
                        .display2
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  Text(
                    "The expense sharing app.",
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 100),
                  Image(
                    image: AssetImage(
                      'assets/graphics/transfer.png',
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SignInButton(
                          Buttons.Google,
                          onPressed: () async {
                            final user = await Auth.googleSignIn();
                            if (user != null)
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home(user)),
                                  ModalRoute.withName("/"));
                          },
                        ),
                        RaisedButton(
                          child: Text("Create Account"),
                          onPressed: () {
                            Navigator.pushNamed(context, Register.id);
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Sign In",
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, Login.id);
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

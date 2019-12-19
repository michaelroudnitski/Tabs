import 'package:flutter/material.dart';
import 'package:tabs/services/auth.dart';

class ForgotPass extends StatefulWidget {
  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool emailSent = false;

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter a valid Email';
    else
      return null;
  }

  void _submitForm() async {
    if (_formKey.currentState.validate()) {
      try {
        setState(() async {
          await Auth.resetPassword(_emailController.text);
          emailSent = true;
        });
      } catch (e) {
        setState(() {
          emailSent = true;
          print(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: !emailSent
              ? Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "Forgot Your Password?",
                        style: Theme.of(context).textTheme.display1,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Enter your email and we'll send you instructions.",
                        style: Theme.of(context).textTheme.body1,
                      ),
                      SizedBox(height: 36),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        controller: _emailController,
                        validator: (value) => validateEmail(value),
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      SizedBox(height: 12),
                      RaisedButton(
                        child: Text("Submit"),
                        onPressed: _submitForm,
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Reset email sent to",
                        style: Theme.of(context).textTheme.headline),
                    // SizedBox(height: 12),
                    Text(_emailController.text,
                        style: Theme.of(context).textTheme.subhead),
                    SizedBox(height: 36),
                    Text("Please check your email",
                        style: Theme.of(context).textTheme.subhead),
                  ],
                ),
        ),
      ),
    );
  }
}

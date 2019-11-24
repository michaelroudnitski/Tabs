import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tabs/services/auth.dart';
import './home.dart';

class Register extends StatefulWidget {
  static const String id = "/register";

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool loading = false;
  String errorMessage = "";

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
    errorMessage = "";
    if (_formKey.currentState.validate()) {
      try {
        setState(() {
          loading = true;
        });
        final user =
            await Auth.signUp(_emailController.text, _passwordController.text);
        if (user != null)
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home(user)),
              ModalRoute.withName("/"));
      } catch (e) {
        print(e);
        setState(() {
          loading = false;
          errorMessage = e.message;
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
      body: loading
          ? Center(
              child: SpinKitDoubleBounce(
                color: Theme.of(context).primaryColor,
                size: 50.0,
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Create Account",
                          style: Theme.of(context)
                              .textTheme
                              .display1
                              .copyWith(color: Theme.of(context).primaryColor),
                        ),
                        SizedBox(height: 36),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                controller: _emailController,
                                validator: (value) => validateEmail(value),
                                onFieldSubmitted: (v) {
                                  FocusScope.of(context).nextFocus();
                                },
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  prefixIcon: Icon(Icons.email),
                                ),
                              ),
                              SizedBox(height: 12),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _passwordController,
                                validator: (value) {
                                  if (value.length < 8)
                                    return "Password must be at least 8 characters";
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon: Icon(Icons.lock),
                                ),
                                obscureText: true,
                              ),
                              SizedBox(height: 12),
                              Text(errorMessage,
                                  style: TextStyle(color: Colors.red)),
                              SizedBox(height: 12),
                              RaisedButton(
                                padding: EdgeInsets.all(14),
                                child: Text("Sign Up"),
                                onPressed: _submitForm,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Image(
                          image: AssetImage(
                            'assets/graphics/welcome.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

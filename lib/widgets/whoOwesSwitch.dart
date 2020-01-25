import 'package:flutter/material.dart';

class WhoOwesSwitch extends StatefulWidget {
  WhoOwesSwitch({Key key}) : super(key: key);

  @override
  _WhoOwesSwitchState createState() => _WhoOwesSwitchState();
}

class _WhoOwesSwitchState extends State<WhoOwesSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        color: Theme.of(context).primaryColor,
        icon: Icon(Icons.cached),
        onPressed: () {
          print("JD");
        },
      ),
    );
  }
}

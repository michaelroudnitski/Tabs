import 'package:flutter/material.dart';
import 'package:tabs/create.form.dart';

class NewTab extends StatelessWidget {
  static const String id = "create_page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Tab")),
      body: Center(child: CreateForm()),
    );
  }
}

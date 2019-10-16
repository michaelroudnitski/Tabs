import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

class CreateForm extends StatefulWidget {
  @override
  _CreateFormState createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  PermissionStatus _permission;
  List<String> _contacts;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  void _updatePermission(PermissionStatus permission) {
    if (permission == PermissionStatus.unknown)
      _askPermission();
    else if (permission != _permission) {
      if (permission == PermissionStatus.granted) {
        ContactsService.getContacts(withThumbnails: false).then(_setContacts);
      }
    }
  }

  _askPermission() {
    PermissionHandler()
        .requestPermissions([PermissionGroup.contacts]).then(_checkPermission);
  }

  _checkPermission([Map<PermissionGroup, PermissionStatus> statuses]) {
    if (statuses != null) {
      _updatePermission(statuses[PermissionGroup.contacts]);
    } else {
      PermissionHandler()
          .checkPermissionStatus(PermissionGroup.contacts)
          .then(_updatePermission);
    }
  }

  _setContacts(Iterable<Contact> contacts) {
    setState(() {
      _contacts = contacts.map((contact) => contact.displayName).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_contacts != null && _contacts.length > 0 ? _contacts[0] : ""),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: "Name",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.attach_money),
                  hintText: "Amount",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the amount owed';
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    Firestore.instance.collection("tabs").add({
                      "name": _nameController.text,
                      "amount": double.parse(_amountController.text),
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

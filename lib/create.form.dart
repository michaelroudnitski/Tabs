import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CreateForm extends StatefulWidget {
  @override
  _CreateFormState createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _pageViewController = PageController();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

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
      _contacts = contacts
          .map((contact) => contact.displayName != null
              ? contact.displayName
              : contact.givenName)
          .toList();
    });
  }

  List<String> _getContactsSuggestions(String pattern) {
    if (_contacts != null && _contacts.length > 0 && pattern.length > 0) {
      return _contacts
          .where((contact) =>
              contact.toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    }
    return null;
  }

  Widget buildPage(
      {@required String title,
      @required String description,
      @required Widget textField,
      bool isLast}) {
    void onPress() {
      if (_formKey.currentState.validate()) {
        if (isLast == null) {
          FocusScope.of(context).unfocus();
          _pageViewController.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.ease,
          );
        } else {
          Firestore.instance.collection("tabs").add({
            "name": _nameController.text,
            "amount": double.parse(_amountController.text),
            "description": _descriptionController.text,
          });
          Navigator.pop(context);
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.display1,
        ),
        Text(description),
        SizedBox(height: 42),
        textField,
        Expanded(
          child: Align(
            alignment: Alignment.bottomRight,
            child: RaisedButton(
              onPressed: () async {
                onPress();
              },
              child: Text(isLast == null ? 'Next' : 'Submit'),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: PageView(
          controller: _pageViewController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            buildPage(
              title: "Name",
              description: "Enter the name of the person who owes you money.",
              textField: TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                    borderRadius: BorderRadius.circular(8.0)),
                suggestionsCallback: _getContactsSuggestions,
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  _nameController.text = suggestion;
                },
                hideOnError: true,
                hideOnEmpty: true,
                validator: (value) {
                  if (value.isEmpty) return 'Please provide a name';
                  return null;
                },
              ),
            ),
            buildPage(
              title: "Amount",
              description: "Enter the amount ${_nameController.text} owes you",
              textField: TextFormField(
                controller: _amountController,
                autofocus: true,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value.isEmpty) return 'Please enter the amount owed';
                  if (double.tryParse(value) == null)
                    return "Please enter a valid number";
                  return null;
                },
              ),
            ),
            buildPage(
              isLast: true,
              title: "What's this for?",
              description:
                  "Why does ${_nameController.text} owe you \$${_amountController.text}?",
              textField: TextFormField(
                controller: _descriptionController,
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.message),
                ),
                validator: (value) {
                  if (value.isEmpty) return 'Please enter a reason';
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

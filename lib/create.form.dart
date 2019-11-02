import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tabs/services/contacts.dart';
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
  List<Widget> _pages;
  double _formProgress = 0.15;

  Widget buildPage({
    @required String title,
    @required String description,
    @required Widget textField,
    bool isLast,
  }) {
    void onPress() {
      if (_formKey.currentState.validate()) {
        _formProgress += 1 / _pages.length;
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

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
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
                child: Text(isLast == true ? 'Submit' : 'Next'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _pages = [
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
          suggestionsCallback: (pattern) async {
            return await Contacts.queryContacts(pattern);
          },
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
    ];

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          LinearProgressIndicator(
              value: _formProgress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor)),
          Expanded(
            child: PageView(
              controller: _pageViewController,
              physics: NeverScrollableScrollPhysics(),
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}

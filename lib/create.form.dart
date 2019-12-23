import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tabs/controllers/tabsController.dart';
import 'package:tabs/services/contacts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CreateForm extends StatefulWidget {
  @override
  _CreateFormState createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _pageViewController = PageController();
  final _textControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  List<Widget> _pages;
  double _formProgress = 0.15;

  @override
  void initState() {
    super.initState();
    Contacts.checkPermission();
  }

  void _submitTab() {
    TabsController.createTab(
      name: _textControllers[0].text,
      amount: double.parse(_textControllers[1].text),
      description: _textControllers[2].text,
    );
    Navigator.pop(context);
  }

  Widget buildPage({
    @required String title,
    @required String description,
    @required Widget textField,
    @required int pageIndex,
    List<String> suggestions,
  }) {
    void goBack() {
      _formProgress -= 1 / _pages.length;
      _pageViewController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
      FocusScope.of(context).unfocus();
    }

    void goNext() {
      _formProgress += 1 / _pages.length;
      _pageViewController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
      FocusScope.of(context).unfocus();
    }

    List<Widget> generateSuggestions() {
      if (suggestions == null) return [];
      List<Widget> chips = [];
      for (String suggestion in suggestions) {
        chips.add(Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ActionChip(
            label: Text(suggestion),
            backgroundColor: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            onPressed: () {
              _textControllers[pageIndex].text = suggestion;
            },
          ),
        ));
      }
      return chips;
    }

    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.display1,
          ),
          Text(description),
          AnimationLimiter(
            child: Row(
              children: AnimationConfiguration.toStaggeredList(
                delay: Duration(milliseconds: 150),
                duration: Duration(milliseconds: 200),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 70.0,
                  child: FadeInAnimation(
                    duration: Duration(milliseconds: 300),
                    child: widget,
                  ),
                ),
                children: generateSuggestions(),
              ),
            ),
          ),
          suggestions != null && suggestions.length > 0
              ? SizedBox(height: 12)
              : SizedBox(height: 42),
          textField,
          Expanded(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Text(pageIndex == 0 ? "Cancel" : "Back"),
                    onPressed: () {
                      if (pageIndex == 0)
                        Navigator.pop(context);
                      else
                        goBack();
                    },
                  ),
                  RaisedButton(
                    child: Text(pageIndex == 2 ? 'Submit' : 'Next'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        if (pageIndex == 2) {
                          _submitTab();
                        } else {
                          goNext();
                        }
                      }
                    },
                  ),
                ],
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
        pageIndex: 0,
        title: "Name",
        description: "Enter the name of the person who owes you money.",
        textField: TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: _textControllers[0],
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            decoration: InputDecoration(prefixIcon: Icon(Icons.person)),
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
            _textControllers[0].text = suggestion;
          },
          hideOnError: true,
          hideOnEmpty: true,
          validator: (value) {
            if (value.isEmpty) return 'Please provide a name';
            return null;
          },
        ),
        suggestions: ["John", "Debrah", "Dad"],
      ),
      buildPage(
        pageIndex: 1,
        title: "Amount",
        description: "Enter the amount ${_textControllers[0].text} owes you",
        textField: TextFormField(
          controller: _textControllers[1],
          autofocus: true,
          inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(prefixIcon: Icon(Icons.attach_money)),
          validator: (value) {
            if (value.isEmpty) return 'Please enter the amount owed';
            if (double.tryParse(value) == null)
              return "Please enter a valid number";
            return null;
          },
        ),
        suggestions: ["5", "20", "50"],
      ),
      buildPage(
          pageIndex: 2,
          title: "What's this for?",
          description:
              "Why does ${_textControllers[0].text} owe you \$${_textControllers[1].text}?",
          textField: TextFormField(
            controller: _textControllers[2],
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.message),
            ),
            validator: (value) {
              if (value.isEmpty) return 'Please enter a reason';
              if (value.length > 21)
                return 'Surpassed character limit. ${value.length}/21';
              return null;
            },
          ),
          suggestions: ["Food", "Rent", "A job well done"]),
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

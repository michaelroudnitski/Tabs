import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:tabs/controllers/tabsController.dart';
import 'package:tabs/providers/suggestionsState.dart';
import 'package:tabs/services/contacts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tabs/providers/settingsState.dart';

// TODO: refactor this monstrosity of a class

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
  final _focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
  List<Widget> _pages;
  int _pageIndex = 0;
  double _formProgress = 0.15;
  bool userOwesFriend = false;
  bool suggestionsRemovable = false;

  @override
  void dispose() {
    // Clean up the focus nodes when the Form is disposed.
    _focusNodes.forEach((element) {
      element.dispose();
    });

    super.dispose();
  }

  void _submitTab() {
    TabsController.createTab(
      name: _textControllers[0].text,
      amount: double.parse(_textControllers[1].text),
      description: _textControllers[2].text,
      userOwesFriend: userOwesFriend,
    );
    Navigator.pop(context);
  }

  void goBack() {
    setState(() {
      _formProgress -= 1 / _pages.length;
      _focusNodes[--_pageIndex].requestFocus();
      suggestionsRemovable = false;
    });
    _pageViewController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  void goNext() {
    setState(() {
      _formProgress += 1 / _pages.length;
      _focusNodes[++_pageIndex].requestFocus();
      suggestionsRemovable = false;
    });
    _pageViewController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget buildPage({
    @required String title,
    @required String description,
    @required Widget textField,
    @required int pageIndex,
    Widget option,
    Suggestions suggestionsState,
    List<String> suggestions,
  }) {
    List<Widget> generateSuggestions() {
      if (suggestions == null) return [];
      List<Widget> chips = [];
      for (String suggestion in suggestions) {
        chips.add(Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: suggestionsRemovable
              ? Chip(
                  label: Text(suggestion),
                  backgroundColor: Colors.white,
                  deleteIconColor: Colors.red,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  onDeleted: () {
                    if (pageIndex == 0)
                      suggestionsState.removeName(suggestion);
                    else if (pageIndex == 2)
                      suggestionsState.removeDescription(suggestion);
                  },
                )
              : ActionChip(
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
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(description),
          if (suggestions != null && suggestions.length > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: AnimationLimiter(
                    child: Container(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
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
                  ),
                ),
                if (pageIndex != 1)
                  IconButton(
                      color: Theme.of(context).primaryColor,
                      icon: Icon(
                          suggestionsRemovable ? Icons.done_all : Icons.edit),
                      onPressed: () {
                        setState(() {
                          suggestionsRemovable = !suggestionsRemovable;
                        });
                      }),
              ],
            ),
          suggestions != null && suggestions.length > 0
              ? SizedBox(height: 12)
              : SizedBox(height: 42),
          Row(
            children: <Widget>[
              Flexible(child: textField),
              if (option != null) option,
            ],
          ),
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
                  Consumer<Suggestions>(
                    builder: (_, suggestionsState, __) => RaisedButton(
                      child: Text(pageIndex == 2 ? 'Submit' : 'Next'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          if (pageIndex == 2) {
                            _submitTab();
                            suggestionsState.updateSuggestions(
                              _textControllers[0].text,
                              _textControllers[1].text,
                              _textControllers[2].text,
                            );
                          } else {
                            goNext();
                          }
                        }
                      },
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

  List<Widget> buildPages(
    BuildContext context,
    Suggestions suggestionsState,
    SettingsState settingsState,
  ) {
    _pages = [
      buildPage(
        pageIndex: 0,
        title: "Name",
        description:
            "Enter the name of the person who you're making this tab for.",
        textField: TypeAheadFormField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: _textControllers[0],
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            focusNode: _focusNodes[0],
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
        suggestions: suggestionsState.suggestions["names"],
        suggestionsState: suggestionsState,
      ),
      buildPage(
        pageIndex: 1,
        title: "Amount",
        description: userOwesFriend
            ? "Enter the amount you owe ${_textControllers[0].text}."
            : "Enter the amount ${_textControllers[0].text} owes you.",
        option: IconButton(
          color: userOwesFriend ? Colors.red : Theme.of(context).primaryColor,
          icon: Icon(Icons.swap_horiz),
          visualDensity: VisualDensity.comfortable,
          enableFeedback: true,
          tooltip: "Tap to change who owes who",
          onPressed: () {
            setState(() {
              userOwesFriend = !userOwesFriend;
            });
          },
        ),
        textField: TextFormField(
          controller: _textControllers[1],
          focusNode: _focusNodes[1],
          inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(prefixIcon: Icon(Icons.card_giftcard)),
          validator: (value) {
            if (value.isEmpty) return 'Please enter the amount owed';
            if (double.tryParse(value) == null)
              return "Please enter a valid number";
            return null;
          },
        ),
        suggestions: suggestionsState.suggestions["amounts"],
        suggestionsState: suggestionsState,
      ),
      buildPage(
        pageIndex: 2,
        title: "What's this for?",
        description: userOwesFriend
            ? "Why do you owe ${_textControllers[0].text} ${settingsState.selectedCurrency}${_textControllers[1].text}?"
            : "Why does ${_textControllers[0].text} owe you ${settingsState.selectedCurrency}${_textControllers[1].text}?",
        textField: TextFormField(
          controller: _textControllers[2],
          focusNode: _focusNodes[2],
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
        suggestions: suggestionsState.suggestions["descriptions"],
        suggestionsState: suggestionsState,
      ),
    ];
    return _pages;
  }

  @override
  Widget build(BuildContext context) {
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
            child: ChangeNotifierProvider(
              create: (context) => Suggestions(),
              child: Consumer<Suggestions>(
                builder: (context, suggestionsState, __) => PageView(
                  controller: _pageViewController,
                  physics: NeverScrollableScrollPhysics(),
                  children: buildPages(
                    context,
                    suggestionsState,
                    Provider.of<SettingsState>(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

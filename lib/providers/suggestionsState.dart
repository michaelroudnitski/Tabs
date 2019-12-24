import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:tabs/controllers/suggestionsController.dart';

class Suggestions extends ChangeNotifier {
  Map<String, List<String>> suggestions = {
    "names": [],
    "amounts": ["5", "10", "20", "50"],
    "descriptions": ["Food", "Rent", "A job well done"]
  };

  Suggestions() {
    updateFromDatabase();
  }

  void updateFromDatabase() async {
    Map<String, dynamic> suggestions =
        await SuggestionsController.fetchSuggestions();
    print(suggestions);
    if (suggestions != null) this.suggestions = suggestions;
    notifyListeners();
  }
}

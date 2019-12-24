import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:tabs/controllers/suggestionsController.dart';

class Suggestions extends ChangeNotifier {
  static const int _NAMES_LEN = 3;
  static const int _AMOUNTS_LEN = 5;
  static const int _DESCRIPTIONS_LEN = 3;
  /* defaults */
  Map<String, List<String>> suggestions = {
    "names": [],
    "amounts": ["5", "10", "20", "50"],
    "descriptions": ["Food", "Rent", "A job well done"]
  };

  Suggestions() {
    _fetchFromDatabase();
  }

  void _fetchFromDatabase() async {
    Map<String, dynamic> suggestions =
        await SuggestionsController.fetchSuggestions();
    if (suggestions != null) this.suggestions = suggestions;
    notifyListeners();
  }

  void updateSuggestions(String name, String amount, String description) {
    _updateNames(name);
    // TODO: amounts & descriptions
    notifyListeners();
    SuggestionsController.updateSuggestions(suggestions);
  }

  void _updateNames(String name) {
    /* Use queues as LRU cache */
    DoubleLinkedQueue<String> names = Queue.of(suggestions["names"]);
    if (names.contains(name)) {
      names.remove((a) => a == name);
      names.addFirst(name);
    } else {
      if (names.length >= _NAMES_LEN) names.removeLast();
      names.addFirst(name);
    }
    suggestions["names"] = List.of(names);
  }
}

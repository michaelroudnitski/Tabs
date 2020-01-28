import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:tabs/controllers/suggestionsController.dart';
import 'dart:math';

class Suggestions extends ChangeNotifier {
  static const int _NAMES_LEN = 3;
  static const int _DESCRIPTIONS_LEN = 3;
  Map<String, dynamic> _savedSuggestions = {
    "names": [],
    "amounts": ["5", "10", "20", "50"],
    "descriptions": Map<String, int>()
  };

  Suggestions() {
    _fetchFromDatabase();
  }

  Map<String, List<String>> get suggestions {
    /* only need to convert descriptions from freq map to list */
    Map<String, List<String>> formatted = Map();
    formatted["names"] = _savedSuggestions["names"].cast<String>();
    formatted["amounts"] = _savedSuggestions["amounts"].cast<String>();
    formatted["descriptions"] = _freqMapToList(
      _savedSuggestions["descriptions"],
      _DESCRIPTIONS_LEN,
    );
    return formatted;
  }

  void _fetchFromDatabase() async {
    Map<String, dynamic> suggestions =
        await SuggestionsController.fetchSuggestions();
    if (suggestions != null) _savedSuggestions = suggestions;
    notifyListeners();
  }

  void updateSuggestions(String name, String amount, String description) {
    _updateNames(name);
    _updateDescriptions(description);
    notifyListeners();
    SuggestionsController.updateSuggestions(_savedSuggestions);
  }

  void _updateNames(String name) {
    /* Use queues as LRU cache */
    DoubleLinkedQueue<String> names =
        DoubleLinkedQueue.of(suggestions["names"]);
    if (names.contains(name))
      names.remove(name);
    else if (names.length >= _NAMES_LEN) names.removeLast();
    names.addFirst(name);
    _savedSuggestions["names"] = List.of(names);
  }

  void _updateDescriptions(String description) {
    Map<String, int> descriptionsMap = _savedSuggestions["descriptions"];
    if (descriptionsMap.containsKey(description))
      descriptionsMap[description]++;
    else {
      if (descriptionsMap.length >= 6) {
        /* remove the least frequent entry */
        int minimum = descriptionsMap.values.reduce(min);
        for (String key in descriptionsMap.keys) {
          if (descriptionsMap[key] == minimum) {
            descriptionsMap.remove(key);
            break;
          }
        }
      }
      descriptionsMap[description] = 1;
    }
  }

  void removeName(String name) {
    _savedSuggestions["names"].remove(name);
    notifyListeners();
    SuggestionsController.updateSuggestions(_savedSuggestions);
  }

  void removeDescription(String description) {
    _savedSuggestions["descriptions"].remove(description);
    print(_savedSuggestions["descriptions"]);
    notifyListeners();
    SuggestionsController.updateSuggestions(_savedSuggestions);
  }

  /// returns k most frequent items in frequency map
  List<String> _freqMapToList(Map<String, int> map, int k) {
    List<int> frequencies = map.values.toList();
    k = min(k, frequencies.length);
    frequencies.sort((a, b) => b.compareTo(a)); // descending
    Map<String, int> frequencyMapCopy = Map.of(map);
    List<String> descriptions = List();
    for (int i = 0; i < k; i++) {
      int current = frequencies[i];
      String descriptionToAdd = frequencyMapCopy.keys
          .firstWhere((key) => frequencyMapCopy[key] == current);
      descriptions.add(descriptionToAdd);
      frequencyMapCopy.remove(descriptionToAdd);
    }
    return descriptions;
  }
}

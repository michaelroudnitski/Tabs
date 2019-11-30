import 'package:flutter/material.dart';

class FilterState with ChangeNotifier {
  FilterState();

  String nameFilter = "";
  bool filterEnabled = false;

  void filterByName(String name) {
    filterEnabled = !filterEnabled;
    if (filterEnabled)
      nameFilter = name;
    else
      nameFilter = "";
    notifyListeners();
  }

  void removeFilter() {
    nameFilter = "";
    filterEnabled = false;
    notifyListeners();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TabsState with ChangeNotifier {
  String _name = "";

  String get name => _name;
  
  bool get filterEnabled => _name != "";

  bool nameMatches(String name) {
    if (!filterEnabled) return true;
    return name == _name;
  }

  List<DocumentSnapshot> openTabs(QuerySnapshot tabs) {
    return tabs.documents
        .where((t) => t["closed"] == false)
        .where((t) => nameMatches(t["name"]))
        .toList();
  }

  List<DocumentSnapshot> closedTabs(QuerySnapshot tabs) {
    return tabs.documents
        .where((t) => t["closed"] == true)
        .where((t) => nameMatches(t["name"]))
        .toList();
  }

  void filterByName(String name) {
    filterEnabled ? _name = "" : _name = name;
    notifyListeners();
  }
}

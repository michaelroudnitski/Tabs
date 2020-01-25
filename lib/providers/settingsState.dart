import 'package:flutter/material.dart';

class SettingsState with ChangeNotifier {
  SettingsState();

  String selectedCurrency = "";

  void selectCurrency(String currency) {
    selectedCurrency = currency;
    print(selectedCurrency);
    notifyListeners();
  }
}

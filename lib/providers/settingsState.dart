import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SettingsState with ChangeNotifier {
  static const currencies = [
    '\$',
    '€',
    '¥',
    '£',
    '元',
    'kr',
    '₩',
    '₹',
    '₽',
    'R',
    'zł',
    '฿',
    '₪'
  ];
  String selectedCurrency = "\$";

  SettingsState() {
    fetchSettings();
  }

  void selectCurrency(String currency) {
    selectedCurrency = currency;
    notifyListeners();
    updateSettings();
  }

  void fetchSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String currency = prefs.getString('currency') ?? "\$";
      print(currency);
      if (currency != "\$") selectCurrency(currency);
    } catch (e) {
      return null;
    }
  }

  void updateSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', selectedCurrency);
  }
}

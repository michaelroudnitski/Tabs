import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

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
  Currency selectedCurrency = Currencies.find("USD");

  SettingsState() {
    CommonCurrencies().registerAll();
    fetchSettings();
  }

  void selectCurrency(String currencyCode) {
    selectedCurrency = Currencies.find(currencyCode);
    notifyListeners();
    updateSettings();
  }

  void fetchSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String currency = prefs.getString('currency') ?? "USD";
      print(currency);
      selectCurrency(currency);
    } catch (e) {
      return null;
    }
  }

  void updateSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', selectedCurrency.code);
  }
}

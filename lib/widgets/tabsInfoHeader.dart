import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:tabs/providers/filterState.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:tabs/providers/settingsState.dart';

class TabsInfoHeader extends StatelessWidget {
  final List<DocumentSnapshot> openTabs;

  TabsInfoHeader(this.openTabs);

  String getTotalAmountFormatted(
      List<DocumentSnapshot> tabs, String currencySymbol) {
    double total = 0;
    for (DocumentSnapshot tab in tabs) {
      if (tab["closed"] != true)
        tab["userOwesFriend"] == true
            ? total -= tab["amount"]
            : total += tab["amount"];
    }
    return "$currencySymbol ${FlutterMoneyFormatter(amount: total).output.nonSymbol}";
  }

  String getHeaderText(List<DocumentSnapshot> tabs) {
    String text = "${tabs.length} OPEN TAB";
    if (tabs.length != 1) text += "S";
    return text;
  }

  Widget displayFilterChip(String name, Function onDeleted) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      child: Chip(
        backgroundColor: Colors.white70,
        label: Text("$name's tabs"),
        onDeleted: onDeleted,
        deleteIcon: Icon(Icons.clear),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> tabs;
    if (Provider.of<FilterState>(context).filterEnabled)
      tabs = openTabs
          .where((doc) =>
              doc["name"] == Provider.of<FilterState>(context).nameFilter)
          .toList();
    else
      tabs = openTabs;

    return Container(
      height:
          Provider.of<FilterState>(context).filterEnabled || tabs.length == 0
              ? 150
              : 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: tabs.length > 0
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            getHeaderText(tabs),
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
              getTotalAmountFormatted(
                  tabs, Provider.of<SettingsState>(context).selectedCurrency),
              style: Theme.of(context).textTheme.display2),
          SizedBox(
            height: 10,
          ),
          if (Provider.of<FilterState>(context).filterEnabled)
            displayFilterChip(
              Provider.of<FilterState>(context).nameFilter,
              Provider.of<FilterState>(context).removeFilter,
            ),
        ],
      ),
    );
  }
}

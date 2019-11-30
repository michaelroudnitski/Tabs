import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tabs/providers/filterState.dart';
import 'package:tabs/widgets/tabsGrid.dart';

class TabsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuerySnapshot>(
      builder: (context, tabsData, child) {
        if (tabsData == null)
          return Center(
            child: SpinKitDoubleBounce(
              color: Theme.of(context).primaryColor,
              size: 50.0,
            ),
          );
        else if (tabsData.documents.length > 0)
          return ChangeNotifierProvider<FilterState>(
            builder: (context) => FilterState(),
            child: Column(
              children: <Widget>[
                TabsInfoHeader(
                  tabsData.documents,
                ),
                Expanded(
                    child:
                        PageView(children: <Widget>[TabsGrid(), Container()])),
              ],
            ),
          );
        else
          return Column(
            children: <Widget>[
              TabsInfoHeader(tabsData.documents),
              SizedBox(
                height: 100,
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/graphics/not-found.png'),
                    ),
                    Text("You don't have any open tabs")
                  ],
                ),
              ),
            ],
          );
      },
    );
  }
}

class TabsInfoHeader extends StatelessWidget {
  final Iterable<DocumentSnapshot> tabsData;

  TabsInfoHeader(this.tabsData);

  String getTotalAmountFormatted(List<DocumentSnapshot> tabs) {
    double total = 0;
    for (DocumentSnapshot tab in tabs) {
      if (tab["amount"] != null) total += tab["amount"];
    }
    return FlutterMoneyFormatter(amount: total).output.symbolOnLeft;
  }

  String getHeaderText(List<DocumentSnapshot> tabs) {
    String text = "${tabs.length} OPEN TAB";
    if (tabs.length != 1) text += "S";
    return text;
  }

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> tabs;
    if (Provider.of<FilterState>(context).filterEnabled)
      tabs = tabsData
          .where((doc) =>
              doc["name"] == Provider.of<FilterState>(context).nameFilter)
          .toList();
    else
      tabs = tabsData;
    return Container(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            getHeaderText(tabs),
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Text(getTotalAmountFormatted(tabs),
              style: Theme.of(context).textTheme.display2),
        ],
      ),
    );
  }
}

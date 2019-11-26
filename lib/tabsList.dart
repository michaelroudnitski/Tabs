import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tabs/widgets/tabsGrid.dart';

class TabsList extends StatelessWidget {
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
          return Column(
            children: <Widget>[
              TabsInfoHeader(tabsData),
              Expanded(child: TabsGrid()),
            ],
          );
        else
          return Column(
            children: <Widget>[
              TabsInfoHeader(tabsData),
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
  final QuerySnapshot tabsData;

  TabsInfoHeader(this.tabsData);

  String getTotalAmountFormatted() {
    double total = 0;
    for (DocumentSnapshot tab in tabsData.documents) {
      if (tab["amount"] != null) total += tab["amount"];
    }
    return FlutterMoneyFormatter(amount: total).output.symbolOnLeft;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            "${tabsData.documents.length} OPEN TABS",
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Text(getTotalAmountFormatted(),
              style: Theme.of(context).textTheme.display2)
        ],
      ),
    );
  }
}

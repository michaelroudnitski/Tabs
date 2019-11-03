import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabs/widgets/tabCard.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class TabsList extends StatelessWidget {
  String getTotalAmountFormatted(QuerySnapshot tabsData) {
    double total = 0;
    for (DocumentSnapshot tab in tabsData.documents) {
      total += tab["amount"];
    }
    return FlutterMoneyFormatter(amount: total).output.symbolOnLeft;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuerySnapshot>(
      builder: (context, tabsData, child) {
        if (tabsData != null)
          return Column(
            children: <Widget>[
              Container(
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text("${tabsData.documents.length} open tabs"),
                    Text(getTotalAmountFormatted(tabsData),
                        style: TextStyle(
                          // color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 36,
                        )),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  padding: EdgeInsets.all(8.0),
                  itemCount: tabsData.documents.length,
                  itemBuilder: (context, index) {
                    return TabCard(
                      tab: tabsData.documents[index],
                    );
                  },
                ),
              ),
            ],
          );
        else
          return Text("No open tabs");
      },
    );
  }
}

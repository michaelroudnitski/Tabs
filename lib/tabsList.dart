import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabs/widgets/tabCard.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
              Container(
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      "${tabsData.documents.length} OPEN TABS",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(getTotalAmountFormatted(tabsData),
                        style: Theme.of(context).textTheme.display2)
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
          return Column(
            children: <Widget>[
              Container(
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      "${tabsData.documents.length} OPEN TABS",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(getTotalAmountFormatted(tabsData),
                        style: Theme.of(context).textTheme.display2)
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Center(
                child: Text("NO OPEN TABS"),
              ),
            ],
          );
      },
    );
  }
}

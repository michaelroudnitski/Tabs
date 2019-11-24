import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabs/widgets/tabCard.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TabsList extends StatelessWidget {
  String getTotalAmountFormatted(QuerySnapshot tabsData) {
    double total = 0;
    for (DocumentSnapshot tab in tabsData.documents) {
      if (tab["amount"] != null) total += tab["amount"];
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
                child: AnimationLimiter(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    padding: EdgeInsets.all(8.0),
                    itemCount: tabsData.documents.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 2,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: TabCard(
                              tab: tabsData.documents[index],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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

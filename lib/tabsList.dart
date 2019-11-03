import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:timeago/timeago.dart' as timeago;

class TabsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuerySnapshot>(
      builder: (context, tabsData, child) {
        if (tabsData != null)
          return GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            padding: EdgeInsets.all(8.0),
            itemCount: tabsData.documents.length,
            itemBuilder: (context, index) {
              return TabCard(
                tab: tabsData.documents[index],
              );
            },
          );
        else
          return Text("No open tabs");
      },
    );
  }
}

class TabCard extends StatelessWidget {
  final DocumentSnapshot tab;
  TabCard({@required this.tab});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              this.tab["name"],
              style: Theme.of(context).textTheme.subhead,
            ),
            Text(
              FlutterMoneyFormatter(amount: this.tab["amount"])
                  .output
                  .symbolOnLeft,
              style: Theme.of(context)
                  .textTheme
                  .headline
                  .copyWith(fontWeight: FontWeight.w800),
            ),
            if (this.tab["description"] != null)
              Chip(
                backgroundColor: Theme.of(context).accentColor,
                label: Text(
                  this.tab["description"],
                  style: TextStyle(color: Colors.white),
                ),
              ),
            Expanded(
              child: Align(
                child: Text(
                  timeago.format(this.tab["time"].toDate()),
                  style: Theme.of(context).textTheme.caption,
                ),
                alignment: Alignment.bottomLeft,
              ),
            )
          ],
        ),
      ),
    );
  }
}

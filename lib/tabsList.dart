import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class TabsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuerySnapshot>(
      builder: (context, tabsData, child) {
        if (tabsData != null)
          return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: tabsData.documents.length,
              itemBuilder: (context, index) {
                return TabCard(
                  tab: tabsData.documents[index],
                );
              });
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
              FlutterMoneyFormatter(amount: this.tab["amount"])
                  .output
                  .symbolOnLeft,
            ),
            subtitle: Text(this.tab["name"]),
            trailing: Icon(Icons.receipt),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('PAID'),
                  onPressed: () async {
                    try {
                      await Firestore.instance
                          .collection("tabs")
                          .document(this.tab.documentID)
                          .delete();
                    } catch (e) {}
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

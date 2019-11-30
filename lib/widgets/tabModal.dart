import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:tabs/controllers/tabsController.dart';
import 'package:tabs/widgets/changeAmountDialog.dart';

class TabModal extends StatelessWidget {
  final DocumentSnapshot tab;
  TabModal({@required this.tab});

  @override
  Widget build(BuildContext context) {
    String displayAmount =
        FlutterMoneyFormatter(amount: this.tab["amount"]).output.symbolOnLeft;
    return Container(
      margin: EdgeInsets.only(left: 18, right: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5],
          colors: [
            Colors.white,
            Colors.white.withAlpha(250),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("${this.tab["name"]}'s Tab",
                    style: Theme.of(context)
                        .textTheme
                        .headline
                        .copyWith(fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Description",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        "Amount",
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "${this.tab["description"]}",
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                    Text(
                      "$displayAmount",
                      style: Theme.of(context).textTheme.subtitle,
                    )
                  ],
                ),
                Image(
                  image: AssetImage('assets/graphics/money-guy.png'),
                  fit: BoxFit.scaleDown,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Change Amount"),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ChangeAmountDialog(tab: this.tab);
                            });
                      },
                    ),
                    RaisedButton(
                      child: Text("Mark Paid"),
                      onPressed: () {
                        TabsController.closeTab(this.tab.documentID);
                        Navigator.pop(context);
                      },
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

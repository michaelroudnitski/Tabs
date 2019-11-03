import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class TabModal extends StatelessWidget {
  final DocumentSnapshot tab;
  String _displayAmount;
  TabModal({@required this.tab}) {
    _displayAmount =
        FlutterMoneyFormatter(amount: this.tab["amount"]).output.symbolOnLeft;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("$_displayAmount ${this.tab["name"]}",
                      style: Theme.of(context)
                          .textTheme
                          .headline
                          .copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    "${this.tab["name"]} owes you $_displayAmount\nfor ${this.tab["description"]}",
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  FlatButton(
                    child: Text("Modify"),
                    onPressed: () {},
                  ),
                  RaisedButton(
                    child: Text("Paid"),
                    onPressed: () {
                      Firestore.instance
                          .collection("tabs")
                          .document(this.tab.documentID)
                          .delete()
                          .then((_) {
                        Navigator.pop(context);
                      });
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

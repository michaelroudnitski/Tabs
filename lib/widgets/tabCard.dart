import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tabs/widgets/tabModal.dart';

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
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => TabModal(
              tab: this.tab,
            ),
          );
        },
        splashColor: Theme.of(context).primaryColor,
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
              Chip(
                backgroundColor: Theme.of(context).accentColor.withAlpha(200),
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
      ),
    );
  }
}

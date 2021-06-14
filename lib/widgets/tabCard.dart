import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';
import 'package:tabs/providers/tabsState.dart';
import 'package:tabs/providers/settingsState.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tabs/widgets/tabModal.dart';

class TabCard extends StatelessWidget {
  final DocumentSnapshot tab;
  TabCard({@required this.tab});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onLongPress: () {
          Provider.of<TabsState>(context, listen: false)
              .filterByName(this.tab["name"]);
        },
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) => TabModal(
              tab: this.tab,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                this.tab["name"],
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                Money.from(this.tab["amount"], Currencies.find('USD'))
                    .toString(),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Chip(
                backgroundColor: this.tab["closed"] == true
                    ? Theme.of(context).accentColor.withAlpha(30)
                    : this.tab["userOwesFriend"] == true
                        ? Colors.redAccent.withAlpha(30)
                        : Theme.of(context).primaryColor.withAlpha(30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                label: Text(
                  this.tab["description"],
                  style: TextStyle(
                      color: this.tab["closed"] == true
                          ? Theme.of(context).accentColor
                          : this.tab["userOwesFriend"] == true
                              ? Colors.redAccent
                              : Theme.of(context).primaryColor),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (this.tab["closed"] == true)
                      Text(
                        "Closed",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    Text(
                      timeago.format(this.tab["closed"] == true
                          ? this.tab["timeClosed"].toDate()
                          : this.tab["time"].toDate()),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabs/widgets/tabCard.dart';

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

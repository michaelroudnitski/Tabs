import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tabs/providers/filterState.dart';
import 'package:tabs/widgets/tabsGrid.dart';
import 'package:tabs/widgets/tabsInfoHeader.dart';

class TabsContainer extends StatelessWidget {
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
        else
          return ChangeNotifierProvider<FilterState>(
            builder: (context) => FilterState(),
            child: Column(
              children: <Widget>[
                TabsInfoHeader(
                  tabsData.documents,
                ),
                if (tabsData.documents.length > 0)
                  Expanded(
                    child: PageView(
                      children: <Widget>[TabsGrid(), Container()],
                    ),
                  ),
                if (tabsData.documents.length == 0)
                  Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                        ),
                        Image(
                          image: AssetImage('assets/graphics/not-found.png'),
                        ),
                        Text("You don't have any open tabs")
                      ],
                    ),
                  ),
              ],
            ),
          );
      },
    );
  }
}

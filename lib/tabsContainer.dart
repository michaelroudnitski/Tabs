import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tabs/controllers/tabsController.dart';
import 'package:tabs/providers/filterState.dart';
import 'package:tabs/widgets/tabsGrid.dart';
import 'package:tabs/widgets/tabsInfoHeader.dart';

class TabsContainer extends StatefulWidget {
  @override
  _TabsContainerState createState() => _TabsContainerState();
}

class _TabsContainerState extends State<TabsContainer> {
  int currentPageIndex = 0;

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      height: 12,
      width: isActive ? 24 : 12,
      decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
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
        else
          return ChangeNotifierProvider<FilterState>(
            create: (context) => FilterState(),
            child: Column(
              children: <Widget>[
                TabsInfoHeader(
                  TabsController.filterOpenTabs(tabsData.documents),
                ),
                Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < 2; i++)
                            if (i == currentPageIndex) ...[circleBar(true)] else
                              circleBar(false),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: PageView(
                    onPageChanged: (int page) {
                      setState(() {
                        currentPageIndex = page;
                      });
                    },
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[TabsGrid(true), TabsGrid(false)],
                  ),
                ),
              ],
            ),
          );
      },
    );
  }
}

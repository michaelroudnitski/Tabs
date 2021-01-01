import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabs/controllers/tabsController.dart';
import 'package:tabs/providers/filterState.dart';
import 'package:tabs/widgets/tabCard.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class OpenTabs extends StatelessWidget {
  OpenTabs();

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> tabs;
    return Consumer<QuerySnapshot>(builder: (context, tabsData, child) {
      /* filter tabs if name filter is present */
      if (Provider.of<FilterState>(context).filterEnabled)
        tabs = tabsData.documents
            .where((doc) =>
                doc["name"] == Provider.of<FilterState>(context).nameFilter)
            .toList();
      else
        tabs = tabsData.documents;
      /* filter tabs by closed status */
      tabs = TabsController.filterOpenTabs(tabs);

      if (tabs.length > 0)
        return Column(
          children: <Widget>[
            AnimationLimiter(
              child: Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  padding: EdgeInsets.all(8.0),
                  itemCount: tabs.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: 2,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: TabCard(
                            tab: tabs[index],
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
        return Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Image(
                image: AssetImage('assets/graphics/not-found.png'),
              ),
              Text("You don't have any open tabs"),
            ],
          ),
        );
    });
  }
}

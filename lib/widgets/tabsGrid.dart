import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabs/widgets/tabCard.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TabsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuerySnapshot>(builder: (context, tabsData, child) {
      return AnimationLimiter(
        child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          padding: EdgeInsets.all(8.0),
          itemCount: tabsData.documents.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 375),
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: TabCard(
                    tab: tabsData.documents[index],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

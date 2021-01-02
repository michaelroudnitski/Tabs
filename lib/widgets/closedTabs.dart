import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tabs/controllers/tabsController.dart';
import 'package:tabs/widgets/confirmDialog.dart';
import 'package:tabs/widgets/tabCard.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ClosedTabs extends StatelessWidget {
  final List<DocumentSnapshot> tabs;

  ClosedTabs({@required this.tabs});

  @override
  Widget build(BuildContext context) {
    if (tabs.length > 0)
      return Column(
        children: <Widget>[
          OutlineButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => new ConfirmDialog(
                  title: "Delete all closed tabs?",
                  content: "You cannot undo this action",
                  confirmText: "Delete all",
                  confirm: () {
                    Navigator.of(context).pop();
                    TabsController.deleteAllTabs(tabs);
                  },
                ),
              );
            },
            color: Colors.white,
            textColor: Colors.white,
            child: Text("Delete All"),
          ),
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
              image: AssetImage('assets/graphics/logic.png'),
            ),
            Text("Closed tabs will appear here")
          ],
        ),
      );
  }
}

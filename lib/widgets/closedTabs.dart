import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tabs/controllers/tabsController.dart';
import 'package:tabs/widgets/tabCard.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:tabs/widgets/confirmDialog.dart';

class ClosedTabs extends StatelessWidget {
  final List<DocumentSnapshot> tabs;

  final options = LiveOptions(
    delay: Duration(milliseconds: 0),
    showItemInterval: Duration(milliseconds: 60),
    showItemDuration: Duration(milliseconds: 187),
  );

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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LiveGrid.options(
                itemCount: tabs.length,
                options: options,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (
                  BuildContext context,
                  int index,
                  Animation<double> animation,
                ) =>
                    FadeTransition(
                  opacity: Tween<double>(
                    begin: 0,
                    end: 1,
                  ).animate(animation),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(-2, -0.1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.fastLinearToSlowEaseIn,
                    )),
                    child: TabCard(
                      tab: tabs[index],
                    ),
                  ),
                ),
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

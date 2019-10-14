import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TabsList extends StatefulWidget {
  @override
  _TabsListState createState() => _TabsListState();
}

class _TabsListState extends State<TabsList> {
  final Firestore _firestore = Firestore.instance;
  List<DocumentSnapshot> tabs;

  void getTabs() async {
    QuerySnapshot data = await _firestore.collection("tabs").getDocuments();
    setState(() {
      this.tabs = data.documents;
    });
  }

  @override
  void initState() {
    super.initState();
    this.getTabs();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: this.tabs.length,
        itemBuilder: (context, index) {
          return TabCard(tab: this.tabs[index]);
        });
  }
}

class TabCard extends StatelessWidget {
  DocumentSnapshot tab;
  String _name;
  double _amount;
  TabCard({this.tab}) {
    this._name = this.tab["name"];
    this._amount = this.tab["amount"];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(this._amount.toString()),
            trailing: Icon(Icons.receipt),
            subtitle: Text(this._name),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                // TODO: update button
                // FlatButton(
                //   child: Text('UPDATE'),
                //   onPressed: () {},
                // ),
                FlatButton(
                  child: Text(
                    'PAID',
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    try {
                      Firestore.instance
                          .collection("tabs")
                          .document(this.tab.documentID)
                          .delete();
                    } catch (e) {}
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

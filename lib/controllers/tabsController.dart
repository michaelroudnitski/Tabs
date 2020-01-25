import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tabs/services/auth.dart';

abstract class TabsController {
  static Future createTab({
    String name,
    double amount,
    String description,
    bool userOwesFriend,
  }) async {
    FirebaseUser user = await Auth.getCurrentUser();
    return Firestore.instance.collection("tabs").add({
      "name": name,
      "amount": amount,
      "description": description,
      "time": DateTime.now(),
      "closed": false,
      "userOwesFriend": userOwesFriend,
      "uid": user.uid
    });
  }

  static Stream<QuerySnapshot> getUsersTabs(String uid) {
    return Firestore.instance
        .collection("tabs")
        .where("uid", isEqualTo: uid)
        .snapshots();
  }

  static Future updateAmount(String tabId, double newAmount) {
    return Firestore.instance
        .collection("tabs")
        .document(tabId)
        .updateData({"amount": newAmount});
  }

  static Future closeTab(String tabId) {
    return Firestore.instance
        .collection("tabs")
        .document(tabId)
        .updateData({"closed": true, "timeClosed": DateTime.now()});
  }

  static Future reopenTab(String tabId) {
    return Firestore.instance
        .collection("tabs")
        .document(tabId)
        .updateData({"closed": false, "timeClosed": null});
  }

  static Future deleteTab(String tabId) {
    return Firestore.instance.collection("tabs").document(tabId).delete();
  }

  static List<DocumentSnapshot> filterOpenTabs(
      Iterable<DocumentSnapshot> tabs) {
    return tabs.where((tab) => tab["closed"] != true).toList();
  }

  static List<DocumentSnapshot> filterClosedTabs(
      Iterable<DocumentSnapshot> tabs) {
    return tabs.where((tab) => tab["closed"] == true).toList();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tabs/services/auth.dart';
import 'package:flutter/services.dart';

abstract class TabsController {
  static Stream<QuerySnapshot> getUsersTabs(String uid) {
    return Firestore.instance
        .collection("tabs")
        .where("uid", isEqualTo: uid)
        .snapshots();
  }

  static Future createTab({
    String name,
    double amount,
    String description,
    bool userOwesFriend,
  }) async {
    FirebaseUser user = await Auth.getCurrentUser();
    HapticFeedback.mediumImpact();
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

  static Future updateAmount(String tabId, double newAmount) {
    HapticFeedback.mediumImpact();
    return Firestore.instance
        .collection("tabs")
        .document(tabId)
        .updateData({"amount": newAmount});
  }

  static Future closeTab(String tabId) {
    HapticFeedback.mediumImpact();
    return Firestore.instance
        .collection("tabs")
        .document(tabId)
        .updateData({"closed": true, "timeClosed": DateTime.now()});
  }

  static Future reopenTab(String tabId) {
    HapticFeedback.mediumImpact();
    return Firestore.instance
        .collection("tabs")
        .document(tabId)
        .updateData({"closed": false, "timeClosed": null});
  }

  static Future deleteTab(String tabId) {
    HapticFeedback.mediumImpact();
    return Firestore.instance.collection("tabs").document(tabId).delete();
  }

  static Future<void> closeAllTabs(Iterable<DocumentSnapshot> tabs) async {
    WriteBatch writeBatch = Firestore.instance.batch();
    tabs.forEach((t) {
      writeBatch.updateData(
          t.reference, {"closed": true, "timeClosed": DateTime.now()});
    });
    writeBatch.commit();
    HapticFeedback.mediumImpact();
  }

  static Future<void> deleteAllTabs(Iterable<DocumentSnapshot> tabs) async {
    WriteBatch writeBatch = Firestore.instance.batch();
    tabs.forEach((t) {
      writeBatch.delete(t.reference);
    });
    writeBatch.commit();
    HapticFeedback.mediumImpact();
  }
}

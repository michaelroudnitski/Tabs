import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tabs/services/auth.dart';

abstract class SuggestionsController {
  static Future<Map<String, dynamic>> fetchSuggestions() async {
    try {
      FirebaseUser user = await Auth.getCurrentUser();
      DocumentSnapshot doc = await Firestore.instance
          .collection("suggestions")
          .document(user.uid)
          .get();
      return {
        "names": List<String>.from(doc.data["names"]),
        "amounts": List<String>.from(doc.data["amounts"]),
        "descriptions": Map<String, int>.from(doc.data["descriptions"])
      };
    } catch (e) {
      /* don't need to do anything (we always have default suggestions) */
      return null;
    }
  }

  static void updateSuggestions(Map<String, dynamic> suggestions) async {
    FirebaseUser user = await Auth.getCurrentUser();
    await Firestore.instance
        .collection("suggestions")
        .document(user.uid)
        .setData(suggestions);
  }
}

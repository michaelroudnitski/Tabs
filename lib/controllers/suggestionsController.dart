import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tabs/services/auth.dart';

abstract class SuggestionsController {
  static Map<String, dynamic> _defaultSuggestions = {
    "names": [],
    "amounts": ["5", "10", "20", "50"],
    "descriptions": {"Food": 0, "Rent": 0, "A job well done": 0}
  };

  static Future<Map<String, dynamic>> fetchSuggestions() async {
    try {
      FirebaseUser user = await Auth.getCurrentUser();
      DocumentSnapshot doc = await Firestore.instance
          .collection("suggestions")
          .document(user.uid)
          .get();
      if (doc == null) return _defaultSuggestions;
      return {
        "names": List<String>.from(doc.data["names"]),
        "amounts": List<String>.from(doc.data["amounts"]),
        "descriptions": Map<String, int>.from(doc.data["descriptions"])
      };
    } catch (e) {
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

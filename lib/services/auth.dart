import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class Auth {
  static Future<String> signIn(String email, String password) async {
    AuthResult result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  static Future<String> signUp(String email, String password) async {
    AuthResult result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  static Future<String> googleSignIn() async {
    GoogleSignIn google = GoogleSignIn(
      scopes: <String>['email'],
    );
    try {
      final GoogleSignInAccount googleAccount = await google.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser =
          await FirebaseAuth.instance.currentUser();
      assert(user.uid == currentUser.uid);
      return user.uid;
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<void> googleSignOut() async {
    GoogleSignIn google = GoogleSignIn(
      scopes: <String>['email'],
    );
    await google.signOut();
  }

  static Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  static Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  static Future<void> sendEmailVerification() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.sendEmailVerification();
  }

  static Future<bool> isEmailVerified() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await user.reload();
    return user.isEmailVerified;
  }

  static Future<void> resetPassword(email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}

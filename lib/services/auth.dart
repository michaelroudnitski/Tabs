import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class Auth {
  static Future<String> signIn(String email, String password) async {
    UserCredential result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    User user = result.user;
    return user.uid;
  }

  static Future<String> signUp(String email, String password) async {
    UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User user = result.user;
    return user.uid;
  }

  static Future<String> appleSignIn() async {
    if (!Platform.isIOS) return null;
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email]),
    ]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential appleIdCredential = result.credential;
        final OAuthProvider oAuthProvider = OAuthProvider("apple.com");
        final AuthCredential credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final UserCredential _res =
            await FirebaseAuth.instance.signInWithCredential(credential);
        return _res.user.uid;
        break;
      case AuthorizationStatus.error:
        print(
            "Sign in with Apple failed:\n${result.error.localizedDescription}");
        break;
      case AuthorizationStatus.cancelled:
        print("Sign in with Apple cancelled");
        break;
    }
    return null;
  }

  static Future<String> googleSignIn() async {
    GoogleSignIn google = GoogleSignIn(
      scopes: <String>['email'],
    );
    try {
      final GoogleSignInAccount googleAccount = await google.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = FirebaseAuth.instance.currentUser;
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

  static Future<User> getCurrentUser() async {
    User user = await FirebaseAuth.instance.currentUser;
    return user;
  }

  static Future<void> sendEmailVerification() async {
    User user = await FirebaseAuth.instance.currentUser;
    user.sendEmailVerification();
  }

  static Future<bool> isEmailVerified() async {
    User user = await FirebaseAuth.instance.currentUser;
    try {
      await user.reload();
    } catch (e) {
      return user.emailVerified;
    }
    user = await FirebaseAuth.instance.currentUser;
    return user.emailVerified;
  }

  static Future<void> resetPassword(email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}

import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
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

  static Future<String> appleSignIn() async {
    if (!Platform.isIOS) return null;
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email]),
    ]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential appleIdCredential = result.credential;
        final OAuthProvider oAuthProvider =
            OAuthProvider(providerId: "apple.com");
        final AuthCredential credential = oAuthProvider.getCredential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final AuthResult _res =
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
    try {
      await user.reload();
    } catch (e) {
      return user.isEmailVerified;
    }
    user = await FirebaseAuth.instance.currentUser();
    return user.isEmailVerified;
  }

  static Future<void> resetPassword(email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}

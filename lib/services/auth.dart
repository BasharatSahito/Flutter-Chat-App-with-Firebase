import 'dart:io';
import 'package:chat_app/services/apis.dart';
import 'package:chat_app/widgets.dart/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  // LOGGING INTO THE APP
  static Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      await InternetAddress.lookup("google.com");
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint("ERROR LOGGING IN ${e.toString()}");
      // ignore: use_build_context_synchronously
      Dialogs.showSnackBar(context, "Something went wrong!");
      return null;
    }
  }
}

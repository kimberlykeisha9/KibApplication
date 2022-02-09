import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kib/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'employer.dart';

// Initializes firebase authentication services
FirebaseAuth auth = FirebaseAuth.instance;

class Authorization {
  var currentUser = auth.currentUser;

  bool checkForUser() {
    return currentUser != null;
  }

  Future<void> createUserWithEmail(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      if (currentUser != null && !currentUser!.emailVerified) {
        await currentUser!.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackbar(context, 'The password you have entered is too weak. Please set another one.');
      } else if (e.code == 'email-already-in-use') {
        showSnackbar(context, 'This email account is already in use. Please. use another one.');
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<bool> signInUserWithEmail(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackbar(context,
            'No account has been found under this email address. Please enter another one or create an account.');
      } else if (e.code == 'wrong-password') {
        showSnackbar(context, 'This is not the correct password. Please enter the correct one.');
      }
      print(e);
      return false;
    }
  }

  Future<void> verifyPhoneNumber(String phone, String sms, BuildContext context) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await currentUser!.linkWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            showSnackbar(context, 'This phone number is not valid. Please change it to a valid one.');
          }
          print(e);
        },
        codeSent: (String verificationId, int? resendToken) async {
          storeData('vid', verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          showSnackbar(context, 'This code has timed out. Do you want to resend another one?');
        },
      );
    } on FirebaseException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future<void> changeEmailAddress(String email) async {
    try {
      await currentUser!.updateEmail(email).then((value) => currentUser!.sendEmailVerification());
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  bool checkForEmailValidation() {
    return currentUser!.emailVerified;
  }

  Future<void> linkCredential(String sms) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String verificationId = prefs.getString('vid')!;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: sms);

    try {
      await currentUser!.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await auth.signInWithCredential(credential);
  }
}

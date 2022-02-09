import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kibworker/employee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'style.dart';
import 'package:http/http.dart' as http;

// Initializes firebase authentication services
FirebaseAuth auth = FirebaseAuth.instance;

class Authorization {
  var currentUser = auth.currentUser;
  String token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FwaS5hcHBydXZlLmNvIiwianRpIjoiMWIxYjBjYTctMTNlYy00ZmJlLWJkZTQtOTViZjA1YzM5MGRjIiwiYXVkIjoiZmRlNzM5ZDItOGU4ZC00MDUwLWIyNjgtNDg1ZmVmMDc3M2Q3Iiwic3ViIjoiMWU0OTI3NGUtNjlmZi00OGViLWE4MzktZWM4YzEwNTU2MWM3IiwibmJmIjowLCJzY29wZXMiOlsidmVyaWZpY2F0aW9uX3ZpZXciLCJ2ZXJpZmljYXRpb25fbGlzdCIsInZlcmlmaWNhdGlvbl9kb2N1bWVudCIsInZlcmlmaWNhdGlvbl9pZGVudGl0eSJdLCJleHAiOjE2NDQ2OTE4ODQsImlhdCI6MTY0MjA5OTg4NH0.-4AaEvpX35_JdEFgRJn1YClNAVL0oWS1unq8iEE3ROw";

  bool checkForUser() {
    return currentUser != null;
  }

  Future<http.Response> verifyID(String id) async {
    var response = await http.post(
      Uri.parse('https://api.appruve.co/v1/verifications/ke/national_id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authentication': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'id': id,
      }),
    );
    print('Token : ${token}');
    print(response);
    return response;
  }

  Future<bool> createUserWithEmail(String email, String password, BuildContext context) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      if (currentUser != null && !currentUser!.emailVerified) {
        await currentUser!.sendEmailVerification();
        return true;
      }
      return true;
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
    return false;
  }

  Future<void> changeEmailAddress(String email, String password) async {
    try {
      await currentUser!.updateEmail(email).then((value) => currentUser!.sendEmailVerification());
    } on FirebaseException catch (e) {
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

  bool checkForEmailValidation() {
    return currentUser!.emailVerified;
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
          storeStringData('vid', verificationId);
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

  void linkWithEmail(String smsCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String? vID = prefs.getString('vID');
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: vID!, smsCode: smsCode);
      currentUser!.linkWithCredential(credential);
    } catch (e) {
      print(e);
    }
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

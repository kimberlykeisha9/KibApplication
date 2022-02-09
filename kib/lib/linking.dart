import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'employer.dart';

class Linking extends ChangeNotifier {
  Future<void> searchForWorkers(
    String fname,
    String task,
    String uid,
    String phone,
    String rating,
    String lname,
    String token,
    String amount,
    String longitude,
    String latitude,
  ) async {
    var workerApp = Firebase.app('worker');
    FirebaseFirestore workerDB = FirebaseFirestore.instanceFor(app: workerApp);
    var workerQuery = workerDB
        .collection('users')
        .where('account_status', isEqualTo: 'approved')
        .where('is_engaged', isEqualTo: false)
        .where('token', isNull: false)
        .limit(20)
        .snapshots()
        .timeout(const Duration(minutes: 10), onTimeout: (stream) {
      stream.close();
    });
    try {
      workerQuery.listen(
        (QuerySnapshot snapshot) {
          snapshot.docs.forEach(
            (availableUser) async {
              log(availableUser.id);
              Map<String, dynamic> _data = availableUser.data() as Map<String, dynamic>;
              var search = await http.post(
                Uri.parse('http://192.168.100.240:5000/listen'),
                headers: {
                  'Content-Type': 'application/json',
                },
                body: jsonEncode(
                  {
                    'receiver': availableUser.id,
                    'message': {
                      'token': _data['token'],
                      'data': {
                        'notification-type': 'job',
                        'uid': uid,
                        'first_name': fname,
                        'last_name': lname,
                        'task': task,
                        'amount': amount,
                        'phone': phone,
                        'fcm_token': token,
                        'rating': rating,
                        'location': {
                          'latitude': latitude,
                          'longitude': longitude,
                        },
                      },
                      'notification': {
                        'body': '$fname has a $task job for you. Click to find out more.',
                        'title': 'Available Job',
                      },
                    },
                  },
                ),
              );
              log(search.body);
            },
          );
        },
        cancelOnError: true,
      );
    } on FirebaseException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }
}

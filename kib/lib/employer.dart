import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'authorization.dart';

// Initializes Cloud Firestore
FirebaseFirestore firestore = FirebaseFirestore.instance;
// Initializes Firebase Storage
FirebaseStorage storage = FirebaseStorage.instance;

final String userID = Authorization().currentUser!.uid;

Future<void> storeData(String key, String value) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setString(key, value);
  print(pref.getString(key));
}

storeInfo(String fname, String lname, String phone, String email, String dob) async {
  await storeData('firstName', fname);
  await storeData('lastName', lname);
  await storeData('phoneNumber', phone);
  await storeData('emailAddress', email);
  await storeData('dob', dob);
}

class Employer extends ChangeNotifier {
  var user = firestore.collection('users').doc(userID);
  Reference idStore = storage.ref('users/$userID/id/idimage.png');

  String? get employerPhone {
    return _employerPhoneNumber;
  }

  String? _employerPhoneNumber;

  getPhoneNumber() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _employerPhoneNumber = pref.getString('phoneNumber');
    notifyListeners();
  }

  Future<LocationData> getLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  Future<void> uploadInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _fname = prefs.getString('firstName')!;
    String _lname = prefs.getString('lastName')!;
    String _phone = prefs.getString('phoneNumber')!;
    String _email = prefs.getString('emailAddress')!;
    String _idURL = prefs.getString('idURL')!;
    DateTime _dob = DateTime.parse(DateFormat('dd/MM/yyyy').parse(prefs.getString('dob')!).toString());

    try {
      await user.set({
        'first_name': _fname,
        'last_name': _lname,
        'phone': _phone,
        'email': _email,
        'id': _idURL,
        'dob': Timestamp.fromDate(_dob),
        'account_status': 'pending'
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> uploadId(File id) async {
    try {
      await idStore.putFile(id).then((value) => _storeIdImage());
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> _storeIdImage() async {
    String idURL = await idStore.getDownloadURL();
    await storeData('idURL', idURL);
  }
}

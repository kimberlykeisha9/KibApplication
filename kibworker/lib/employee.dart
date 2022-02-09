import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'authorization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeStringData(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
  print(prefs.getString(key));
}

Future<void> reloadPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.reload();
}

FirebaseStorage storage = FirebaseStorage.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
String userUID = Authorization().currentUser!.uid;

storeInfo(String fname, String lname, String phone, String email, String dob) async {
  await storeStringData('firstName', fname);
  await storeStringData('lastName', lname);
  await storeStringData('phoneNumber', phone);
  await storeStringData('emailAddress', email);
  await storeStringData('dob', dob);
}

checkForLocationPermissions() async {
  Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      location.enableBackgroundMode(enable: true);
      return;
    }
  }
}

class Employee extends ChangeNotifier {
  String? _employeeFirstName;
  String? _employeeLastName;
  String? _employeePhoneNumber;
  String? _employeeDOB;
  String? _employeeProfilePicture;
  String? _employeeEmail;
  double? _employeeLatitude = 0;
  double? _employeeLongitude = 0;
  final double? _employeeRating = 5;
  var userStorage = storage.ref('users/$userUID/');
  var userDatabase = firestore.collection('users').doc(userUID);
  late String _idURL;

  Reference idStore = storage.ref('users/$userUID/id/idimage.png');

  String? get employeeNumber {
    return _employeePhoneNumber;
  }

  String? get employeeFirstName {
    return _employeeFirstName;
  }

  String? get employeeLastName {
    return _employeeLastName;
  }

  double? get employeeLatitude {
    return _employeeLatitude;
  }

  double? get employeeLongitude {
    return _employeeLongitude;
  }

  String? get employeeProfilePicture {
    return _employeeProfilePicture;
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
    await storeStringData('idURL', idURL);
  }

  Future<void> getEmployeeLocation(Completer control) async {
    Location location = Location();
    location.onLocationChanged.listen((LocationData currentLocation) async {
      _employeeLatitude = currentLocation.latitude;
      _employeeLongitude = currentLocation.longitude;
      final GoogleMapController controller = await control.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_employeeLatitude!, _employeeLongitude!),
          ),
        ),
      );
      notifyListeners();
    });
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
      await userDatabase.set({
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

  getPhoneNumber() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _employeePhoneNumber = pref.getString('phoneNumber');
    notifyListeners();
  }
}

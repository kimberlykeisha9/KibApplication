import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kibworker/style.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'authorization.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'employee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'linking.dart';
import 'unverified.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: StreamBuilder<DocumentSnapshot>(
        stream: Employee().userDatabase.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text('Something went wrong. Please restart your application',
                    style: Theme.of(context).textTheme.bodyText1),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.active) {
            Map<String, dynamic> _data = snapshot.data!.data() as Map<String, dynamic>;
            String _accountStatus = _data['account_status'];
            String _fname = _data['first_name'];
            String _lname = _data['last_name'];
            int _balance = _data['account_balance'];
            String _phone = Authorization().currentUser!.phoneNumber as String;
            if (_accountStatus == 'pending' ||
                _accountStatus == 'approved but incomplete' ||
                _accountStatus == 'rejected') {
              return Unverified(_fname, _lname, _phone);
            } else if (_accountStatus == 'approved') {
              return Verified(_fname, _lname, _phone, _balance);
            } else {
              return Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text('Something went wrong. Please restart your application',
                      style: Theme.of(context).textTheme.bodyText1),
                ),
              );
            }
          }
          return Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class Verified extends StatefulWidget {
  final String? fname;
  final String? lname;
  final String? phone;
  final int? balance;
  Verified(this.fname, this.lname, this.phone, this.balance);

  @override
  _VerifiedState createState() => _VerifiedState();
}

class _VerifiedState extends State<Verified> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PermissionStatus? _permission;
  @override
  void initState() {
    super.initState;
    if (Authorization().currentUser == null) {
      Navigator.pushNamed(context, 'Home');
    } else if (Authorization().currentUser!.emailVerified == false) {
      auth.signOut().then((value) => Navigator.pushNamed(context, 'Home'));
    }
    NotificationHandler().notificationEnabler();
    checkForLocationPermissions();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Menu(
          widget.fname!,
          widget.lname!,
          widget.phone!,
        ),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                padding: const EdgeInsets.all(0),
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              ),
              const Icon(Icons.account_circle),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Container(
            height: height,
            width: width,
            padding: const EdgeInsets.all(20),
            child: StreamBuilder<DocumentSnapshot>(
                stream: Employee().userDatabase.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    Map<String, dynamic> _data = snapshot.data!.data() as Map<String, dynamic>;
                    bool? _isEngaged = _data['is_engaged'];
                    if (_isEngaged == true) {
                      return engaged(context, width, height);
                    } else if (_isEngaged == false) {
                      return disengaged(context, width, height);
                    } else {
                      return Container(
                        color: Colors.white,
                        child: Center(
                          child: Text('Something went wrong. Please restart your application',
                              style: Theme.of(context).textTheme.bodyText1),
                        ),
                      );
                    }
                  }
                  return Container(
                    color: Colors.white,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Column engaged(BuildContext context, double width, double height) {
    Completer<GoogleMapController> _controller = Completer();
    if (_permission == PermissionStatus.granted) {
      Provider.of<Employee>(context).getEmployeeLocation(_controller);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            '${greeting()}, ' + widget.fname!,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        Text(
          'Current Task',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        Container(
          padding: const EdgeInsets.only(top: 20),
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.account_circle,
                size: 120,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.fname! + ' ' + widget.lname!, style: Theme.of(context).textTheme.bodyText1),
                          PopupMenuButton(
                            elevation: 0,
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Text('Call ' + widget.fname!),
                              ),
                              PopupMenuItem(
                                child: Text('Text ' + widget.fname!),
                              ),
                              PopupMenuItem(
                                child: Text('Report ' + widget.fname!),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text('${widget.phone}'),
                      const Text('Rating: 4.8/5'),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: width * 0.25,
                              child: OutlinedButton(
                                onPressed: () => null,
                                child: Text('CALL'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.25,
                              child: OutlinedButton(
                                onPressed: () => null,
                                child: Text('TEXT'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            widget.fname! + '\'s Live Location',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: width,
          height: height * 0.15,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.5,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                Provider.of<Employee>(context).employeeLatitude!,
                Provider.of<Employee>(context).employeeLongitude!,
              ),
              zoom: 19.151926040649414,
            ),
            mapType: MapType.satellite,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(20),
            width: width,
            height: height * 0.15,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.5,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Task to be done'),
                    Text('Light Laundry'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Amount Due'),
                    Text('Ksh. 350'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Service Provider Fee'),
                    Text('Ksh. 280'),
                  ],
                ),
              ],
            )),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: width * 0.4,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('FINISH JOB'),
                  ),
                ),
                SizedBox(
                  width: width * 0.4,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('CANCEL JOB'),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Column disengaged(BuildContext context, double width, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Text(
            '${greeting()}, ${widget.fname!}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        Text(
          'Earnings',
          style: Theme.of(context).textTheme.caption,
        ),
        Flexible(
          flex: 6,
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            width: width,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.5,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Available balance', style: Theme.of(context).textTheme.caption),
                    Spacer(flex: 1),
                    Text('KES ${widget.balance.toString()}.00',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    Spacer(flex: 1),
                    Container(
                      margin: const EdgeInsets.only(top: 0),
                      width: width * 0.48,
                      child: OutlinedButton(
                        onPressed: () => Authorization().verifyID('00000001').then((value) => print(value.body)),
                        child: const Text('WITHDRAW'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Spacer(
          flex: 2,
        ),
        Text(
          'Job Status',
          style: Theme.of(context).textTheme.caption,
        ),
        Spacer(),
        Flexible(
          flex: 8,
          child: Row(
            children: [
              Container(
                height: height * 0.35,
                width: width * 0.475,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.5,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Spacer(flex: 2),
                      Text(
                        'No active jobs',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      const Spacer(),
                      Text(
                        'You aren\'t engaged at the moment.',
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String greeting() {
    int _hour = DateTime.now().hour;
    if (_hour < 12) {
      return 'Good Morning';
    } else if (_hour < 17) {
      return 'Good Afternoon';
    } else if (_hour < 24) {
      return 'Good Evening';
    }
    return 'Good Morning';
  }
}

class Menu extends StatelessWidget {
  final String fname, lname, phone;
  const Menu(this.fname, this.lname, this.phone, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        height: height,
        width: width * 0.75,
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  'assets/Logo.svg',
                  color: Theme.of(context).colorScheme.primary,
                  height: 21,
                ),
                Text(
                  'KIB',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Hero(
                  tag: 'menu',
                  child: Icon(
                    Icons.menu,
                    color: Theme.of(context).colorScheme.primary,
                    size: 27,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home_outlined,
                    size: 21,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  TextButton(
                    onPressed: null,
                    child: Text(
                      'Home',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.forum_outlined,
                  size: 21,
                  color: Theme.of(context).colorScheme.primary,
                ),
                TextButton(
                  onPressed: null,
                  child: Text(
                    'Chats',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.history_edu_outlined,
                  size: 21,
                  color: Theme.of(context).colorScheme.primary,
                ),
                TextButton(
                  onPressed: null,
                  child: Text(
                    'History',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.badge_outlined,
                  size: 21,
                  color: Theme.of(context).colorScheme.primary,
                ),
                TextButton(
                  onPressed: null,
                  child: Text(
                    'Profile',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.settings_outlined,
                  size: 21,
                  color: Theme.of(context).colorScheme.primary,
                ),
                TextButton(
                  onPressed: null,
                  child: Text(
                    'Settings',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outlined,
                  size: 21,
                  color: Theme.of(context).colorScheme.primary,
                ),
                TextButton(
                  onPressed: null,
                  child: Text(
                    'Privacy Policy',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.public_outlined,
                  size: 21,
                  color: Theme.of(context).colorScheme.primary,
                ),
                TextButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => const WebView(
                      initialUrl: 'https://www.google.com',
                    ),
                  ),
                  child: Text(
                    'Website',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.help_outlined,
                  size: 21,
                  color: Theme.of(context).colorScheme.primary,
                ),
                TextButton(
                  onPressed: null,
                  child: Text(
                    'FAQs',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout_outlined,
                  size: 21,
                  color: Theme.of(context).colorScheme.primary,
                ),
                TextButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Text(
                        'Are you sure you want to log out?',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => NotificationHandler()
                              .deleteFCMToken()
                              .then((value) => auth.signOut().then((val) => Navigator.pushNamed(context, 'Home'))),
                          child: const Text(
                            'Log Out',
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop,
                          child: Text(
                            'Cancel',
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: Text(
                    'Log Out',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.account_circle,
                            size: 30,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(fname + ' ' + lname, style: Theme.of(context).textTheme.bodyText1),
                            Text(phone, style: Theme.of(context).textTheme.caption),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

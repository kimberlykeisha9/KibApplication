import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'authorization.dart';
import 'chores.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'employer.dart';
import 'linking.dart';
import 'style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'unverified.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Employer().user.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(userID);
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('Something went wrong on our end. Please restart your application',
                  style: Theme.of(context).textTheme.bodyText1),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.active) {
          Map<String, dynamic> _data = snapshot.data!.data() as Map<String, dynamic>;
          String _accountStatus = _data['account_status'];
          String _fname = _data['first_name'];
          String _lname = _data['last_name'];
          String _phone = Authorization().currentUser!.phoneNumber as String;
          if (_accountStatus == "approved") {
            return Verified(
              fname: _fname,
              lname: _lname,
              phone: _phone,
            );
          } else if (_accountStatus == "pending" ||
              _accountStatus == "rejected" ||
              _accountStatus == "approved but incomplete") {
            return Unverified(
              fname: _fname,
              lname: _lname,
              phone: _phone,
            );
          } else {
            return const Center(
              child: Text(
                'Something went wrong. Please restart your application',
              ),
            );
          }
        }
        return Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class Verified extends StatefulWidget {
  final String fname;
  final String lname;
  final String phone;
  const Verified({
    Key? key,
    required this.fname,
    required this.lname,
    required this.phone,
  }) : super(key: key);

  @override
  _VerifiedState createState() => _VerifiedState();
}

// ignore: unused_local_variable
double _currentLat = 37.43296265331129;
// ignore: unused_local_variable
double _currentLong = -122.08832357078792;

class _VerifiedState extends State<Verified> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final CameraPosition _currentLocationOnMap = CameraPosition(
    target: LatLng(_currentLat, _currentLong),
    zoom: 14.4746,
  );

  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState;
    if (Authorization().currentUser == null) {
      Navigator.pushNamed(context, 'Home');
    } else if (Authorization().currentUser!.emailVerified == false) {
      auth.signOut().then((value) => Navigator.pushNamed(context, 'Home'));
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width,
      height: height,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Hero(
                tag: 'menu',
                child: GestureDetector(
                  onTap: () => _scaffoldKey.currentState?.openDrawer(),
                  child: Icon(
                    Icons.menu,
                    color: Theme.of(context).colorScheme.primary,
                    size: 27,
                  ),
                ),
              ),
              Icon(
                Icons.account_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 27,
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(
              20,
            ),
            child: StreamBuilder<DocumentSnapshot>(
                stream: Employer().user.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    Map<String, dynamic> _data = snapshot.data!.data() as Map<String, dynamic>;
                    bool _isEngaged = _data['is_engaged'];
                    if (_isEngaged == true) {
                      return engaged(width, height, context, _isEngaged);
                    } else {
                      return disengaged(context, _isEngaged, width);
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ),
        drawer: Menu(
          widget.fname,
          widget.lname,
          widget.phone,
        ),
      ),
    );
  }

  Column disengaged(BuildContext context, bool _isEngaged, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Spacer(),
        RichText(
          text: TextSpan(
            text: _greeting(),
            style: Theme.of(context).textTheme.bodyText1,
            children: [
              TextSpan(
                text: ' ${widget.fname}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Spacer(),
        Text('What would you like to do today?', style: Theme.of(context).textTheme.subtitle1),
        Spacer(),
        Expanded(
          flex: 12,
          child: GridView.count(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 10,
            padding: const EdgeInsets.all(0),
            childAspectRatio: 1.5,
            children: chores
                .map(
                  (chore) => GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(
                          'You have selected ${chore.chore}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'Await');
                              // Employer().getLocation().then((currentLocation) => Linking()
                              //     .searchForWorkers(
                              //       widget.fname,
                              //       chore.chore,
                              //       userID,
                              //       widget.phone,
                              //       '4.5',
                              //       widget.lname,
                              //       'abcd',
                              //       chore.amount.toString(),
                              //       currentLocation.longitude.toString(),
                              //       currentLocation.latitude.toString(),
                              //     )
                              //     .whenComplete(() => {Navigator.of(context).popAndPushNamed('Await')}));
                            },
                            child: Text(
                              'Proceed',
                            ),
                          ),
                          TextButton(
                            onPressed: Navigator.of(context).pop,
                            child: Text(
                              'Cancel',
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: Wrap(
                      children: [
                        Container(
                          width: width * 0.4,
                          height: (width * 0.4) * 1.25,
                          padding: const EdgeInsets.symmetric(
                            vertical: 60,
                            horizontal: 45,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                          child: Image.asset(
                            chore.icon,
                          ),
                        ),
                        Container(
                          width: width * 0.4,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              chore.chore,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Spacer(),
      ],
    );
  }

  Column engaged(double width, double height, BuildContext context, bool _isEngaged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Current Task', style: Theme.of(context).textTheme.caption),
        Flexible(
          flex: 5,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.account_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 120,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${widget.fname} ${widget.lname}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          PopupMenuButton(
                            padding: const EdgeInsets.all(0),
                            initialValue: 1,
                            icon: const Icon(Icons.more_vert, size: 21),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Text(
                                  'Call ${widget.fname}',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text(
                                  'Text ${widget.fname}',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              PopupMenuItem(
                                value: 3,
                                child: Text(
                                  'Report ${widget.fname}',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${widget.phone}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Spacer(),
                    Text(
                      '4.5/5',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Spacer(),
                    Flexible(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 7,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.all(7.5),
                              ),
                              onPressed: () => null,
                              child: Text(
                                'Call',
                              ),
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 7,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.all(7.5),
                              ),
                              onPressed: () => null,
                              child: Text(
                                'Chat',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Container(
          child: Text(
            '${widget.fname}\'s Live Location',
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Expanded(
          flex: 8,
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.5,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            /*  child: GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: _currentLocationOnMap,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ), */
          ),
        ),
        Spacer(),
        Flexible(
          flex: 4,
          child: Container(
            width: width,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.5,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Task to be done', style: Theme.of(context).textTheme.caption),
                    Text('Amount Due', style: Theme.of(context).textTheme.caption),
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Laundry', style: Theme.of(context).textTheme.caption),
                  Text('ksh. 350', style: Theme.of(context).textTheme.caption),
                ])
              ],
            ),
          ),
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 7,
                child: ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Text(
                        'Are you sure you want to complete this job?',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop;
                            setState(() => _isEngaged == false);
                          },
                          child: Text(
                            'Yes',
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop,
                          child: Text(
                            'No',
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: Text(
                    'Finish Job',
                  ),
                )),
            Spacer(),
            Expanded(
                flex: 7,
                child: ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Text(
                        'Are you sure you want to cancel this job?',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop;
                            setState(() => _isEngaged == false);
                          },
                          child: Text(
                            'Yes',
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop,
                          child: Text(
                            'No',
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: Text(
                    'Cancel Job',
                  ),
                )),
          ],
        )
      ],
    );
  }

  String _greeting() {
    var _hour = DateTime.now().hour;

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
                          onPressed: () => auth.signOut().then((val) => Navigator.pushNamed(context, 'Home')),
                          child: Text(
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
            Spacer(),
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
                            Text('${fname + ' ' + lname}', style: Theme.of(context).textTheme.bodyText1),
                            Text('$phone', style: Theme.of(context).textTheme.caption),
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

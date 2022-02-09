import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'authorization.dart';
import 'dashboard.dart';
import 'employer.dart';
import 'style.dart';

class Unverified extends StatefulWidget {
  final String fname;
  final String lname;
  final String phone;
  const Unverified({Key? key, required this.fname, required this.lname, required this.phone}) : super(key: key);

  @override
  _UnverifiedState createState() => _UnverifiedState();
}

class _UnverifiedState extends State<Unverified> {
  void initState() {
    super.initState;
    if (Authorization().currentUser == null) {
      Navigator.pushNamed(context, 'Home');
    } else if (Authorization().currentUser!.emailVerified == false) {
      auth.signOut().then((value) => Navigator.pushNamed(context, 'Home'));
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: RichText(
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
                ),
                Container(
                  height: height * 0.7,
                  width: width,
                  margin: const EdgeInsets.only(
                    top: 40,
                  ),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1.5,
                    ),
                  ),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: Employer().user.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.active) {
                          Map<String, dynamic> _data = snapshot.data!.data() as Map<String, dynamic>;
                          String _accountStatus = snapshot.data!['account_status'];
                          if (_accountStatus == "pending") {
                            return const Pending();
                          } else if (_accountStatus == "approved but incomplete") {
                            return Incomplete(width: width);
                          } else if (_accountStatus == "rejected") {
                            return const Rejected();
                          } else {
                            return const Center(
                              child: Text(
                                'Something went wrong. Please restart your application',
                              ),
                            );
                          }
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ),
              ],
            ),
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

class Incomplete extends StatelessWidget {
  final double width;

  const Incomplete({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(flex: 3),
        Text(
          'Your account has been approved',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        Spacer(),
        Text(
          'Congratulations on getting your Kib account approved!',
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
        Spacer(),
        Text(
          'All that is left to do is upload your picture and set up your working preferences and you will be good to go.',
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
        Spacer(),
        Text(
          'Click the button below to proceed to the next page.',
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
        Spacer(flex: 2),
        SizedBox(width: width, child: OutlinedButton(onPressed: () => null, child: Text('Continue'))),
        Spacer(flex: 3),
      ],
    );
  }
}

class Rejected extends StatelessWidget {
  const Rejected({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(flex: 3),
        Text(
          'Your account has been rejected',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        Spacer(),
        Text(
          'There was something wrong with your application. Don\'t worry, it most likely is not major and can be fixed easily. Kindly check your email to receive further guidance on how to get your account approved.',
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
        Spacer(flex: 3),
      ],
    );
  }
}

class Pending extends StatelessWidget {
  const Pending({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(flex: 2),
        Text(
          'Your account is under review',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        Spacer(),
        Text('Our team is yet to review your application. We will notify you as soon as we check it.',
            style: Theme.of(context).textTheme.bodyText1, textAlign: TextAlign.center),
        Spacer(),
        Text(
          'In the mean time, you can go through some of the key things we expect from you so that you are fully informed.',
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
        Spacer(flex: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/EG.svg',
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        'Employee Guidelines',
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/ToU.svg',
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        'Terms of Use',
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Spacer(flex: 2),
      ],
    );
  }
}

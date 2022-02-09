import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'dashboard.dart';
import 'employee.dart';

class Unverified extends StatelessWidget {
  final String? fname;
  final String? lname;
  final String? phone;

  const Unverified(this.fname, this.lname, this.phone);

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
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
      drawer: Menu(
          fname!,
          lname!,
          phone!,
        ),
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${greeting()}, $fname',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  width: width,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: const Color(0xFF134545),
                    ),
                  ),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: Employee().userDatabase.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.active) {
                          Map<String, dynamic> _data = snapshot.data!.data() as Map<String, dynamic>;
                          String _accountStatus = _data['account_status'];
                          if (_accountStatus == 'pending') {
                            return const Pending();
                          } else if (_accountStatus == 'rejected') {
                            return Rejected();
                          } else if (_accountStatus == 'approved but incomplete') {
                            return ToBeCompleted(width: width);
                          } else {
                            return Center(
                              child: Text('Something went wrong. Please restart the application'),
                            );
                          }
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
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

class ToBeCompleted extends StatelessWidget {
  const ToBeCompleted({
    required this.width,
    Key? key,
  }) : super(key: key);

  final double width;

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

class Pending extends StatelessWidget {
  const Pending({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Your account is under review',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        Text(
          'Our team is yet to review your application. We will notify you as soon as we check it.',
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
        Text(
          'In the meantime, you can go through some of the key things we expect from you so that you are fully informed.',
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 1.5,
                        color: const Color(0xFF00AC7C),
                      ),
                    ),
                    child: SvgPicture.asset(
                      'assets/EG.svg',
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Employee Guidelines',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 1.5,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: SvgPicture.asset(
                      'assets/ToU.svg',
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Terms of Use',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'employee.dart';

class AwaitVerification extends StatefulWidget {
  const AwaitVerification({Key? key}) : super(key: key);

  @override
  _AwaitVerificationState createState() => _AwaitVerificationState();
}

class _AwaitVerificationState extends State<AwaitVerification> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                'assets/Logo.svg',
                color: Theme.of(context).primaryColor,
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  'All done',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Text(
                  'Thank you for signing up with Kib.',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Text(
                  'We need to verify your details in order to activate your account which should not take more than 48 hours. If there is any issue with your account, we will send you an email. Do remember to verify your email address in order to sign in.',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Text(
                  'We look forward to working with you!',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                width: width,
                child: ElevatedButton(
                  child: const Text('GO TO HOME'),
                  onPressed: () => Employee().uploadInformation().then(
                        (value) => Navigator.pushNamed(context, 'Home'),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

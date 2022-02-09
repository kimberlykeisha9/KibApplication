import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kib/employer.dart';
import 'style.dart';

class AwaitVerification extends StatefulWidget {
  const AwaitVerification({Key? key}) : super(key: key);

  @override
  _AwaitVerificationState createState() => _AwaitVerificationState();
}

class _AwaitVerificationState extends State<AwaitVerification> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final _formKey = GlobalKey<FormState>();
    // Timer function for time left
    return SizedBox(
      width: width,
      height: height,
      child: Form(
        key: _formKey,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                      tag: 'logo',
                      child: SvgPicture.asset(
                        'assets/Logo.svg',
                        color: Theme.of(context).colorScheme.primary,
                        width: 27,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 40),
                      alignment: Alignment.center,
                      child: Text(
                        'All done',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 30,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Thank you for signing up with Kib!',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 30,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'We need to verify your details in order to fully activate your account which shouldn\'t take more than 48 hours. If there is any issue, we will send you an email. Also ensure you have verified your email in order to access your account.',
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: 30,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'We look forward to working with you!',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 60,
                        ),
                        width: width,
                        child: ElevatedButton(
                          onPressed: () => Employer().uploadInformation().then(
                                (value) => Navigator.pushNamed(context, 'Home'),
                              ),
                          child: Text(
                            'Go to Home',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

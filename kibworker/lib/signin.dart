import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kibworker/linking.dart';
import 'package:kibworker/style.dart';

import 'authorization.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

var _currentUser = Authorization().currentUser;

class _SignInState extends State<SignIn> {
  final _email = TextEditingController(),
      _pass = TextEditingController(),
      _oldEmail = TextEditingController(),
      _newEmail = TextEditingController(),
      _confirmation = TextEditingController(),
      _formKey = GlobalKey<FormState>(),
      _changeMail = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    alignment: Alignment.centerLeft,
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SvgPicture.asset(
                    'assets/Logo.svg',
                    color: Theme.of(context).primaryColor,
                    height: 35,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  'Log In',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 40,
                ),
                child: Text(
                  'Sign back into your Kib account',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Text(
                        'Email Address',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller: _email,
                          autofillHints: const [AutofillHints.email],
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter an email address';
                            if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          'Password',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller: _pass,
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter a password';
                          },
                          obscureText: true,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 30),
                        alignment: Alignment.topRight,
                        child: TextButton(
                          child: Text(
                            'FORGOT PASSWORD?',
                          ),
                          onPressed: () => null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: width,
                child: ElevatedButton(
                  child: const Text('SIGN IN'),
                  onPressed: () => {
                    if (_formKey.currentState!.validate() == true)
                      Authorization().signInUserWithEmail(_email.text, _pass.text, context).then(
                            (value) => {
                              if (value == true)
                                if (Authorization().checkForEmailValidation() == true)
                                  {
                                    NotificationHandler()
                                        .uploadFCMToken()
                                        .then((value) => Navigator.pushNamed(context, 'Dashboard')),
                                  }
                                else
                                  {_unverifiedEmailDialog(context, height, width)},
                            },
                          ),
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: width,
                child: TextButton(
                  child: const Text(
                    '''DON\'T HAVE AN ACCOUNT?
REGISTER HERE''',
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () => Navigator.pushNamed(context, 'Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _unverifiedEmailDialog(BuildContext context, double height, double width) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text('Unconfirmed Email', style: Theme.of(context).textTheme.subtitle2),
          content: Text(
            'You have not confirmed your email yet. Kib requires you to confirm your email in order to access your account. Would you like us to resend your verification email or would you like to change it?',
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.left,
          ),
          actions: [
            TextButton(
                child: Text('Resend Verification'),
                onPressed: () {
                  _currentUser!.sendEmailVerification().then(
                        (value) => auth.signOut().then((value) {
                          Navigator.of(context).pop();
                          showSnackbar(context, 'Kindly check your email account');
                        }),
                      );
                }),
            /*  TextButton(
                child: Text(
                  'Change Email',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Change email address'),
                      content: Container(
                        height: height * 0.4,
                        width: width,
                        child: Form(
                          key: _changeMail,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextFormField(
                                controller: _oldEmail,
                                validator: (val) {
                                  if (val!.isEmpty) return 'Please enter your old email address';
                                  if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)) {
                                    return 'Please enter a valid email address';
                                  }
                                  if (val != Authorization().currentUser!.email) return 'Enter the right email address';
                                },
                                decoration: const InputDecoration(labelText: 'Old Email'),
                              ),
                              TextFormField(
                                controller: _newEmail,
                                validator: (val) {
                                  if (val!.isEmpty) return 'Please enter your new email address';
                                  if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)) {
                                    return 'Please enter a valid email address';
                                  }
                                },
                                decoration: const InputDecoration(labelText: 'New Email'),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_changeMail.currentState!.validate() == true) {
                                    Authorization().changeEmailAddress(_newEmail.text, _confirmation.text).then(
                                        (value) => auth.signOut().then((value) => {
                                              Navigator.of(context).pop(),
                                              showSnackbar(context,
                                                  'Your email has been changed. Check your mail to verify it in order to sign in'),
                                            }), onError: (e) {
                                      showSnackbar(context, e);
                                    });
                                  } else {
                                    showSnackbar(context, 'Something has gone wrong');
                                  }
                                },
                                child: const Text('Change Email Address'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  auth.signOut();
                                },
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }), */
            TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  auth.signOut().then((value) {
                    Navigator.of(context).pop();
                  });
                }),
          ],
        ),
      ),
    );
  }
}

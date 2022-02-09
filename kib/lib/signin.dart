import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animate_do/animate_do.dart';
import 'style.dart';
import 'authorization.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _pass = TextEditingController(), _email = TextEditingController(), _oldEmail = TextEditingController(), _newEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>(), _changeMail = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width,
      height: height,
      child: Form(
        key: _formKey,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        iconSize: 27,
                        padding: const EdgeInsets.all(0),
                        icon: Icon(
                          Icons.arrow_back_sharp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () => Navigator.pop(context),
                        alignment: Alignment.centerLeft,
                      ),
                      Hero(
                        tag: 'logo',
                        child: SvgPicture.asset(
                          'assets/Logo.svg',
                          color: Theme.of(context).colorScheme.primary,
                          width: 27,
                        ),
                      ),
                    ],
                  ),
                  SlideInLeft(
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      padding: const EdgeInsets.only(top: 40),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Welcome back',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                  ),
                  SlideInLeft(
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      padding: const EdgeInsets.only(top: 20, bottom: 40),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sign back into your Kib account',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        SlideInUp(
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            padding: const EdgeInsets.only(top: 0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Email',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        SlideInUp(
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            width: width,
                            child: TextFormField(
                              controller: _email,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your email address';
                                }
                                if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ),
                        SlideInUp(
                          duration: const Duration(milliseconds: 400),
                          child: Container(
                            padding: const EdgeInsets.only(top: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        SlideInUp(
                          duration: const Duration(milliseconds: 400),
                          child: Container(
                            width: width,
                            child: TextFormField(
                              controller: _pass,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your password';
                                }
                              },
                              obscureText: true,
                            ),
                          ),
                        ),
                        SlideInUp(
                          duration: const Duration(milliseconds: 500),
                          child: Container(
                            padding: const EdgeInsets.only(top: 10),
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                              ),
                              onPressed: () => null,
                              child: Text(
                                'Forgot Password?',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: SlideInUp(
                      duration: const Duration(milliseconds: 550),
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: width,
                        child: ElevatedButton(
                          onPressed: () => {
                            if (_formKey.currentState!.validate() == true)
                              {
                                Authorization().signInUserWithEmail(_email.text, _pass.text, context).then(
                            (value) => {
                              if (value == true)
                                if (Authorization().checkForEmailValidation() == true)
                                  {Navigator.pushNamed(context, 'Dashboard')}
                                else
                                  {_unverifiedEmailDialog(context, height, width)},
                            },
                          ),
                              }
                            else
                              {showSnackbar(context, 'Oops something went wrong. Please sign in again')}
                          },
                          child: Text(
                            'Sign In',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SlideInUp(
                      duration: const Duration(milliseconds: 650),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                        ),
                        onPressed: () => Navigator.pushNamed(context, 'Sign Up'),
                        child: RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: Theme.of(context).textTheme.caption,
                            children: [
                              TextSpan(
                                text: 'Create one',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
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
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
                child: Text('Resend Verification'),
                onPressed: () {
                  Authorization().currentUser!.sendEmailVerification().then(
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
                                    Authorization().changeEmailAddress(_newEmail.text).then(
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

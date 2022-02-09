import 'package:animate_do/animate_do.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'authorization.dart';
import 'employer.dart';

import 'style.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool passwordReveal = true, confirmPasswordReveal = true;
  final TextEditingController _fName = TextEditingController(),
      _lName = TextEditingController(),
      _email = TextEditingController(),
      _phone = TextEditingController(),
      _pass = TextEditingController(),
      _confirmPass = TextEditingController(),
      _dob = TextEditingController();

  String _cc = '+254';

  bool _isChecked = false;

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
                        'Create an account',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                  ),
                  SlideInLeft(
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Fill in your details',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SlideInUp(
                      duration: const Duration(milliseconds: 400),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'First Name',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            controller: _fName,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your first name';
                              }
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Last Name',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your last name';
                              }
                            },
                            controller: _lName,
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Email Address',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email address';
                              }
                              if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                            },
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Phone number',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                          TextFormField(
                            maxLength: 9,
                            smartDashesType: SmartDashesType.enabled,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              if (value.length < 9) {
                                return 'Please enter a valid phone number';
                              }
                            },
                            controller: _phone,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              prefixIcon: CountryCodePicker(
                                onChanged: (val) => setState(() => _cc = val.toString()),
                                initialSelection: 'KE',
                                favorite: const [
                                  'KE',
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              top: 20,
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 8) {
                                return 'Please enter a longer password';
                              }
                              if (!value.contains(RegExp(r'[A-Z]'))) {
                                return 'Password must contain a capital letter';
                              }
                              if (!value.contains(RegExp(r'[a-z]'))) {
                                return 'Password must contain a small letter';
                              }
                              if (!value.contains(RegExp(r'[\W]'))) {
                                return 'Password must contain a symbol';
                              }
                              if (!value.contains(RegExp(r'[0-9]'))) {
                                return 'Password must contain number';
                              }
                            },
                            controller: _pass,
                            obscureText: passwordReveal,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => !passwordReveal),
                                icon: Icon(
                                  passwordReveal == true ? Icons.visibility : Icons.visibility_off,
                                ),
                                iconSize: 21,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              top: 20,
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Confirm password',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _pass.text) {
                                return 'Passwords do not match';
                              }
                            },
                            controller: _confirmPass,
                            obscureText: confirmPasswordReveal,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => !confirmPasswordReveal),
                                icon: Icon(
                                  confirmPasswordReveal == true ? Icons.visibility : Icons.visibility_off,
                                ),
                                iconSize: 21,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Date of birth',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your date of birth';
                              }
                            },
                            readOnly: true,
                            controller: _dob,
                            decoration: InputDecoration(
                              hintText: 'Tap the icon on the right',
                              suffixIcon: IconButton(
                                onPressed: () => _selectDOB(context),
                                icon: const Icon(
                                  Icons.today,
                                ),
                                iconSize: 21,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _isChecked,
                                  onChanged: (value) {
                                    setState(() => _isChecked = value!);
                                  },
                                ),
                                Flexible(
                                  child: Text(
                                    'I have read and accept the Terms and Conditions',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SlideInUp(
                    duration: const Duration(milliseconds: 550),
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 20,
                        bottom: 10,
                      ),
                      width: width,
                      child: ElevatedButton(
                        onPressed: () => {
                          if (_formKey.currentState!.validate() == true && _isChecked == true)
                            {
                              Authorization()
                                  .createUserWithEmail(
                                    _email.text,
                                    _pass.text,
                                    context,
                                  )
                                  .then(
                                    (value) => {
                                      if (Authorization().checkForUser() == true)
                                        {
                                          storeInfo(
                                              _fName.text, _lName.text, _cc + _phone.text, _email.text, _dob.text),
                                          Navigator.pushNamed(context, 'Phone Verification')
                                        }
                                    },
                                  ),
                            }
                          else if (_isChecked == false)
                            {showSnackbar(context, 'Please agree to the terms and conditions in order to proceed')}
                        },
                        child: Text(
                          'Create account',
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
                        onPressed: () => Navigator.pushNamed(
                          context,
                          'Sign In',
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: Theme.of(context).textTheme.caption,
                            children: [
                              TextSpan(
                                text: 'Sign In',
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

  _selectDOB(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.year,
      initialDate: DateTime(
        DateTime.now().year - 18,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDate: DateTime(
        DateTime.now().year - 18,
        DateTime.now().month,
        DateTime.now().day,
      ),
      firstDate: DateTime(1920),
      helpText: 'Enter your date of birth',
    );
    if (picked != null) {
      setState(() {
        _dob.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }
}

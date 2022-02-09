import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kibworker/style.dart';

import 'authorization.dart';
import 'employee.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isChecked = false;
  final _formKey = GlobalKey<FormState>(),
      _fname = TextEditingController(),
      _lname = TextEditingController(),
      _email = TextEditingController(),
      _phone = TextEditingController(),
      _dob = TextEditingController(),
      _pass = TextEditingController(),
      _confirmPass = TextEditingController();
  String _cc = '+254';
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
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  'Register',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 30,
                ),
                child: Text(
                  'Enter your details',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Text(
                        'First Name',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller: _fname,
                          autofillHints: [AutofillHints.givenName],
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter your first name';
                          },
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          'Last Name',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller: _lname,
                          autofillHints: [AutofillHints.familyName],
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter your last name';
                          },
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          'Email Address',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextFormField(
                          autofillHints: [AutofillHints.email],
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter your email';
                            if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                          },
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          'Phone Number',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextFormField(
                          autofillHints: [AutofillHints.telephoneNumber],
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter your phone number';
                            if (value.length < 9) return 'Please enter a valid phone number';
                          },
                          maxLength: 9,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          'Date of Birth',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller: _dob,
                          validator: (value) {
                            if (value!.isEmpty) return 'Please enter your date of birth';
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.today),
                              onPressed: () => _selectDOB(context),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          'Password',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextFormField(
                          autofillHints: [AutofillHints.password],
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
                          obscureText: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          'Confirm Password',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) return 'Please confirm your password';
                            if (value != _pass.text) return 'Passwords do not match';
                          },
                          controller: _confirmPass,
                          obscureText: true,
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
              Container(
                margin: const EdgeInsets.only(top: 30),
                width: width,
                child: ElevatedButton(
                    child: const Text('CREATE ACCOUNT'),
                    onPressed: () => {
                          if (_formKey.currentState!.validate() == true && _isChecked == true)
                            {
                              Authorization().createUserWithEmail(_email.text, _pass.text, context).then((value) {
                                if (value == true) {
                                  storeInfo(_fname.text, _lname.text, _cc + _phone.text, _email.text, _dob.text);
                                  Navigator.pushNamed(context, 'Phone Verification');
                                } else {
                                  showSnackbar(context, 'An error has occured. Please try again later');
                                }
                              }, onError: (_) => showSnackbar(context, 'An error has occured. Please try again later')),
                            }
                          else if (_isChecked == false)
                            {showSnackbar(context, 'Please agree to the terms and conditions in order to proceed')}
                        }),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: width,
                child: TextButton(
                  child: const Text('''ALREADY HAVE AN ACCOUNT?
SIGN IN HERE''', textAlign: TextAlign.center),
                  onPressed: () => Navigator.pushNamed(context, 'Sign In'),
                ),
              ),
            ],
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

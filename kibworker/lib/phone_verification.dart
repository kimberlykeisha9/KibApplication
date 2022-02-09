import 'dart:async';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kibworker/style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authorization.dart';
import 'employee.dart';

class PhoneVerification extends StatefulWidget {
  const PhoneVerification({Key? key}) : super(key: key);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  final TextEditingController _smsController = TextEditingController(), _fixedPhone = TextEditingController();
  String? _phoneNumber;
  String _cc = '+254';
  late Timer _timer;
  int _timeLeft = 60;
  bool _activateButton = false;
  final _formKey = GlobalKey<FormState>();

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_timeLeft == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _timeLeft--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    reloadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    reloadPreferences();
    double width = MediaQuery.of(context).size.width;
    Provider.of<Employee>(context).getPhoneNumber();
    _phoneNumber = Provider.of<Employee>(context).employeeNumber;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                    'Verify your phone number',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyText1,
                          text: 'We will you a verification code to the number ',
                          children: [
                            TextSpan(
                              text: _phoneNumber,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: '. Enter the code you receive in the space below.'),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: TextButton(
                          child: Text('Entered the wrong number? Change it'),
                          onPressed: () => showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => AlertDialog(
                              title: Text(
                                'Change Phone Number',
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              content: Wrap(children: [
                                Text(
                                  'Enter your phone number below',
                                  style: Theme.of(context).textTheme.bodyText1,
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
                                    controller: _fixedPhone,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      prefixIcon: CountryCodePicker(
                                        onChanged: (val) => setState(
                                          () => _cc = val.toString(),
                                        ),
                                        initialSelection: 'KE',
                                        favorite: const [
                                          'KE',
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              actions: [
                                TextButton(
                                    child: Text('Change Number'),
                                    onPressed: () => {
                                          storeStringData('phoneNumber', _cc + _fixedPhone.text),
                                          Navigator.of(context).pop()
                                        }),
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Form(
                          key: _formKey,
                          child: PinCodeTextField(
                            controller: _smsController,
                            length: 6,
                            keyboardType: TextInputType.number,
                            appContext: context,
                            onChanged: (val) => null,
                            pinTheme: PinTheme(
                              fieldHeight: 45,
                              fieldWidth: 45,
                              borderWidth: 1.5,
                              activeColor: const Color(0xFF00AC7C),
                              selectedColor: const Color(0xFF00AC7C),
                              inactiveColor: const Color(0xFF134545),
                              shape: PinCodeFieldShape.box,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() => _activateButton = true);
                            Authorization().verifyPhoneNumber(_phoneNumber!, _smsController.text, context);
                            startTimer();
                          },
                          child: Text('Send Code'),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20),
                  width: width,
                  child: ElevatedButton(
                    onPressed: _activateButton
                        ? () => _formKey.currentState!.validate()
                            ? {
                                Authorization().linkCredential(_smsController.text).then((value) => {
                                      if (Authorization().currentUser!.phoneNumber != null)
                                        {
                                          Navigator.pushNamed(context, 'ID'),
                                        }
                                      else
                                        {
                                          showSnackbar(context, 'Phone number is not yet verified'),
                                        }
                                    })
                              }
                            : null
                        : null,
                    child: Text(
                      'Verify',
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  width: width,
                  child: Text('Time left: $_timeLeft s', style: Theme.of(context).textTheme.caption),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

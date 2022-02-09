import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'authorization.dart';
import 'employer.dart';
import 'style.dart';

class PhoneVerification extends StatefulWidget {
  const PhoneVerification({Key? key}) : super(key: key);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  late Timer _timer;
  int timeLeft = 60;
  bool activateButton = false;
  String? _phoneNumber;
  final TextEditingController _smsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (timeLeft == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            timeLeft--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    // super.initState();
    // startTimer();
    // Future.delayed(const Duration(seconds: 60), () => setState(() => activateButton = true));

    // Authorization().verifyPhoneNumber(_phoneNumber!, _smsController.text, context).then((value) => {
    //       if (Authorization().currentUser!.phoneNumber != null) {Navigator.pushNamed(context, 'ID')}
    //     });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    Provider.of<Employer>(context).getPhoneNumber();
    _phoneNumber = Provider.of<Employer>(context).employerPhone;
    return WillPopScope(
      onWillPop: () async => false,
       child: SizedBox(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Container(
                      padding: const EdgeInsets.only(top: 40),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Create an account',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Verify your number',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'We have sent you a verification code to the number ',
                              style: Theme.of(context).textTheme.bodyText1,
                              children: <TextSpan>[
                                TextSpan(
                                  text: _phoneNumber,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: '. Enter the code you receive in the space below.')
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () => null,
                              child: Text(
                                'Entered the wrong number? Change it',
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20.0),
                            width: width * 0.9,
                            child: PinCodeTextField(
                                controller: _smsController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the code';
                                  }
                                  if (value.length < 6) {
                                    return 'Please enter a 6 digit code';
                                  }
                                },
                                keyboardType: TextInputType.number,
                                length: 6,
                                appContext: context,
                                onChanged: (val) => null,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  fieldHeight: 50,
                                  fieldWidth: 50,
                                  activeColor: Theme.of(context).colorScheme.primary,
                                  selectedColor: Theme.of(context).colorScheme.primary,
                                  borderWidth: 1.5,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() => activateButton = true);
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
                        onPressed: activateButton
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
                    Center(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        direction: Axis.vertical,
                        children: [
                          Text('Time left: $timeLeft s', style: Theme.of(context).textTheme.caption),
                          TextButton(
                            onPressed: activateButton
                                ? () {
                                    Authorization()
                                        .verifyPhoneNumber(_phoneNumber!, _smsController.text, context)
                                        .then((value) => {
                                              if (Authorization().currentUser!.phoneNumber != null)
                                                {Navigator.pushNamed(context, 'ID')}
                                            });
                                  }
                                : null,
                            child: const Text(
                              // ignore: unnecessary_string_escapes
                              '''Haven\'t received a code yet?
    Resend it''',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
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

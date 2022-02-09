import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'authorization.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _scroll = PageController();

  @override
  void initState() {
    super.initState();
    if (Authorization().currentUser != null) {
      if (Authorization().currentUser!.emailVerified == false) {
        auth.signOut();
      } else {
        Navigator.pushNamed(context, 'Dashboard');
      }
    }
  }

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
            children: [
              Center(
                child: SvgPicture.asset(
                  'assets/Logo.svg',
                  color: Theme.of(context).primaryColor,
                  height: 35,
                ),
              ),
              Expanded(
                child: PageView(
                  physics: const BouncingScrollPhysics(),
                  controller: _scroll,
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Image.asset('assets/Group 19@4x.png'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            'Get hired fast',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            'Get linked with quick jobs in your area',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Image.asset('assets/Group 20@4x.png'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            'Instant Payments',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            'Paid as soon as you finish via M-Pesa',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                width: width,
                child: ElevatedButton(
                  child: const Text('SIGN IN WITH GOOGLE'),
                  onPressed: () => null,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: width,
                child: ElevatedButton(
                  child: const Text('SIGN IN WITH EMAIL'),
                  onPressed: () => Navigator.pushNamed(context, 'Sign In'),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: width,
                child: OutlinedButton(
                  child: const Text('CREATE AN ACCOUNT'),
                  onPressed: () => Navigator.pushNamed(context, 'Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

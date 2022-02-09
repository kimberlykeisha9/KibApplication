import 'package:flutter/material.dart';
import 'style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'authorization.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Hero(
                  tag: 'logo',
                  child: SvgPicture.asset(
                    'assets/Logo.svg',
                    color: Theme.of(context).colorScheme.primary,
                    width: 27,
                  ),
                ),
              ),
              Spacer(),
              Expanded(flex: 40, child: Container(width: width, padding: const EdgeInsets.all(35), child: Image.asset('assets/Splash@4x.png'))),
              Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: SlideInRight(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: width * 0.5,
                    padding: const EdgeInsets.only(bottom: 20),
                    child: RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                        text: 'Get work done ',
                        style: Theme.of(context).textTheme.headline4,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'fast.',
                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
               Spacer(flex: 2),
              SlideInUp(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                      width: width,
                      child: OutlinedButton(
                        onPressed: () => Authorization().signInWithGoogle(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.google,
                              size: 18,
                            ),
                            Text('Sign in with Google'),
                          ],
                        ),
                      )),
                ),
                Spacer(),
              SlideInUp(
                duration: const Duration(milliseconds: 400),
                child: Container(
                  width: width,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, 'Sign In'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const FaIcon(
                          Icons.email_sharp,
                          size: 18,
                        ),
                        Text('Sign in with Email'),
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
              SlideInUp(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  width: width,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, 'Sign Up'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FaIcon(Icons.person, size: 18, color: Colors.white),
                        Text(
                          'Create an account',
                        ),
                      ],
                    ),
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

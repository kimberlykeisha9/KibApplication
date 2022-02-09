import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Firebase
import 'package:firebase_core/firebase_core.dart';
// UI Components
import 'await_linking.dart';
import 'await_verification.dart';
import 'dashboard.dart';
import 'employer.dart';
import 'firebase_options.dart';
import 'home.dart';
import 'id.dart';
import 'signin.dart';
import 'style.dart';
import 'signup.dart';
import 'phone_verification.dart';
import 'package:provider/provider.dart';
import 'authorization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Firebase.initializeApp(
      name: 'worker',
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBJsKV2F67H0e17B_fzOkGkYcpD-6CiuqM',
        appId: '1:664305180623:android:0badb4a5fcac75e7fc3cba',
        messagingSenderId: '664305180623',
        projectId: 'kib-workers',
      ),
    );
  } catch (e) {
    log(e.toString());
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Employer(),
        )
      ],
      child: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: Text('Something went wrong. Try restarting the application'),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Kib',
                theme: ThemeData(
                  dialogTheme: DialogTheme(
                      titleTextStyle: Theme.of(context).textTheme.subtitle2,
                      contentTextStyle: Theme.of(context).textTheme.bodyText1,
                      shape: const RoundedRectangleBorder()),
                  appBarTheme: const AppBarTheme(
                    elevation: 0,
                    color: Colors.white,
                    toolbarHeight: 60,
                  ),
                  scaffoldBackgroundColor: Colors.white,
                  checkboxTheme: CheckboxThemeData(
                    fillColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF00AC7C),
                    ),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      elevation: 0,
                    ),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                    ),
                  ),
                  outlinedButtonTheme: OutlinedButtonThemeData(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      elevation: 0,
                      side: const BorderSide(
                        color: Color(0xFF00AC7C),
                        width: 1.5,
                      ),
                    ),
                  ),
                  textSelectionTheme: const TextSelectionThemeData(
                    cursorColor: Color(0xFF00ac7c),
                  ),
                  cardColor: const Color(0x1A00AC7C),
                  disabledColor: const Color(0xFF336151),
                  primaryColor: const Color(0xFF00AC7C),
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFF00AC7C),
                    primaryContainer: Color(0xFF00705A),
                    secondary: Color(0xFF134545),
                    secondaryContainer: Color(0xFF061414),
                    onPrimary: Colors.black,
                    onSecondary: Colors.white,
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    labelStyle: GoogleFonts.poppins(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1.5,
                        color: Color(0xFF134545),
                      ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  textTheme: TextTheme(
                    headline1: GoogleFonts.vidaloka(
                      textStyle: const TextStyle(
                        fontSize: 36,
                        color: Color(0xFF134545),
                      ),
                    ),
                    headline2: GoogleFonts.vidaloka(
                      textStyle: const TextStyle(
                        fontSize: 60,
                      ),
                    ),
                    headline3: GoogleFonts.vidaloka(
                      textStyle: const TextStyle(
                        fontSize: 48,
                      ),
                    ),
                    headline4: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF134545),
                      ),
                    ),
                    headline5: GoogleFonts.vidaloka(
                      textStyle: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    headline6: GoogleFonts.vidaloka(
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    subtitle1: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    subtitle2: GoogleFonts.vidaloka(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF134545),
                      ),
                    ),
                    bodyText1: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    bodyText2: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    caption: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    button: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        height: 1.25,
                      ),
                    ),
                  ),
                  cardTheme: const CardTheme(
                    shape: RoundedRectangleBorder(),
                    elevation: 0,
                  ),
                ),
                initialRoute: Authorization().checkForUser() ? 'Dashboard' : 'Home',
                // home: const Home(),
                routes: {
                  'Home': (context) => const Home(),
                  'Sign In': (context) => const SignIn(),
                  'Sign Up': (context) => const SignUp(),
                  'Phone Verification': (context) => const PhoneVerification(),
                  'ID': (context) => const ID(),
                  'Await Verification': (context) => const AwaitVerification(),
                  'Dashboard': (context) => const Dashboard(),
                  'Await': (context) => Await(),
                },
              );
            }
            return Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ));
          }),
    );
  }
}

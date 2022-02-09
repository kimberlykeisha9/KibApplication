import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kibworker/authorization.dart';
import 'package:provider/provider.dart';
import 'employee.dart';
import 'firebase_options.dart';
import 'await_verification.dart';
import 'dashboard.dart';
import 'home.dart';
import 'id.dart';
import 'phone_verification.dart';
import 'signin.dart';
import 'signup.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  log("Handling a background message: ${message.messageId}");
  log(message.data as String);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Employee(),
        ),
      ],
      child: MaterialApp(
        title: 'Kib for Workers',
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
                fontSize: 96,
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
            headline4: GoogleFonts.vidaloka(
              textStyle: const TextStyle(
                fontSize: 36,
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
        home: Authorization().checkForUser() ? const Dashboard() : const Home(),
        // initialRoute: 'Home',
        routes: {
          'Home': (context) => const Home(),
          'Sign In': (context) => const SignIn(),
          'Sign Up': (context) => const SignUp(),
          'Phone Verification': (context) => const PhoneVerification(),
          'ID': (context) => const ID(),
          'Await Verification': (context) => const AwaitVerification(),
          'Dashboard': (context) => const Dashboard(),
        },
      ),
    );
  }
}

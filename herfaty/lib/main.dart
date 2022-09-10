import 'package:flutter/material.dart';
import 'package:herfaty/signupShop.dart';
import 'package:herfaty/splash.dart';
import 'package:herfaty/signupCustomer.dart';
import 'package:herfaty/signupHerafy.dart';
import 'package:herfaty/welcomeRegestration.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("ar", "AE"),
        Locale("ar", "AE"),
      ],
      initialRoute: "/",
      routes: {
        "/": (context) => const Splash(),
        "/welcomeRegestration": (context) => const WelcomeRegestration(),
        "/signupCustomer": (context) => const SignupCustomer(),
        "/signupHerfay": (context) => const SignupHerafy(),
        "/signupShop": (context) => const SignupShop(),
      },
    );
  }
}

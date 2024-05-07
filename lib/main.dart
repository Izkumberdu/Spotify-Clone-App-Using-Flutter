import 'package:flutter/material.dart';
import 'package:lettersquared/screens/homepage.dart';
import 'package:lettersquared/screens/library.dart';
import 'package:lettersquared/screens/onboarding.dart';
import 'package:lettersquared/screens/searchMenu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application. test
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SearchMenu(),
      routes: {
        '/onboarding': (context) => const Onboarding(),
        '/searchMenu': (context) => const SearchMenu(),
        '/homepage': (context) => const Homepage(),
        '/library': (context) => const Library(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lettersquared/screens/choose_artist.dart';
import 'package:lettersquared/screens/homepage.dart';
import 'package:lettersquared/screens/library.dart';
import 'package:lettersquared/screens/onboarding.dart';
import 'package:lettersquared/screens/searchMenu.dart';
import 'package:lettersquared/screens/signup1.dart';
import 'package:lettersquared/screens/start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LetterSquared',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartScreen(),
        '/onboarding': (context) => const Onboarding(),
        '/signup1': (context) => const SignUp1(),
        '/homepage': (context) => const Homepage(),
        '/library': (context) => const Library(),
        '/searchMenu': (context) => const SearchMenu(),
        '/choose_artist': (context) => const ChooseArtist(),
      },
    );
  }
}

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:lettersquared/screens/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Onboarding(),
      routes: {
        '/onboarding': (context) => const Onboarding(),
      },
    );
  }
}

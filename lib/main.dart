import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lettersquared/screens/choose_artist.dart';
import 'package:lettersquared/screens/homepage.dart';
import 'package:lettersquared/screens/library.dart';
import 'package:lettersquared/screens/onboarding.dart';
import 'package:lettersquared/screens/searchMenu.dart';
import 'package:lettersquared/screens/trackview.dart';
import 'package:lettersquared/screens/signup1.dart';
import 'package:lettersquared/screens/start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application. test
  @override
  Widget build(BuildContext context) {
        '/onboarding': (context) => const Onboarding(),
    );
  }
}

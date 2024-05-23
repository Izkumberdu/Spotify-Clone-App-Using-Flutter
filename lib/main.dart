import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lettersquared/screens/homepage.dart';
import 'package:lettersquared/screens/library.dart';
import 'package:lettersquared/screens/playingqueue.dart';
import 'package:lettersquared/screens/search.dart';
import 'package:lettersquared/screens/trackview.dart';
import 'package:lettersquared/screens/signup1.dart';
import 'package:lettersquared/screens/start.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application. test
  @override
 Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const StartScreen(),
        '/onboarding': (context) => const StartScreen(),
        '/homepage': (context) => const Homepage(),
        '/library': (context) => const Library(),
        '/search': (context) => const Search(),
        '/playingqueue': (context) => const AlbumQueuePage(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lettersquared/screens/homepage.dart';
import 'package:lettersquared/screens/library.dart';
import 'package:lettersquared/screens/onboarding.dart';
import 'package:lettersquared/screens/playingqueue.dart';
import 'package:lettersquared/screens/search.dart';
import 'package:lettersquared/screens/searchMenu.dart';
import 'package:lettersquared/screens/trackview.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AlbumQueuePage(), //test 3am
      routes: {
        '/onboarding': (context) => const Onboarding(),
        '/searchMenu': (context) => const SearchMenu(),
        '/homepage': (context) => const Homepage(),
        '/library': (context) => const Library(),
        '/search': (context) => const Search(),
        '/playingqueue': (context) => const AlbumQueuePage(),
      },
    );
  }
}

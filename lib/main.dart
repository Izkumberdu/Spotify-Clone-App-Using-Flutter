import 'package:flutter/material.dart';
import 'package:lettersquared/screens/homepage.dart';
import 'package:lettersquared/screens/library.dart';
import 'package:lettersquared/screens/onboarding.dart';
import 'package:lettersquared/screens/playingqueue.dart';
import 'package:lettersquared/screens/search.dart';
import 'package:lettersquared/screens/searchMenu.dart';
import 'package:lettersquared/screens/trackview.dart';
import 'package:lettersquared/supabase/supabase_connection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeSupabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchMenu(),
      routes: {
        '/onboarding': (context) => const Onboarding(),
        '/searchMenu': (context) => const SearchMenu(),
        '/homepage': (context) => const Homepage(),
        '/library': (context) => const Library(),
        '/search': (context) => const Search(),
        '/trackview': (context) => const Trackview(),
        '/playingqueue': (context) => const AlbumQueuePage(),
      },
    );
  }
}

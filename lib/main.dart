import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lettersquared/screens/homepage.dart';
import 'package:lettersquared/screens/library.dart';
import 'package:lettersquared/screens/playingqueue.dart';
import 'package:lettersquared/screens/playlistview.dart';
import 'package:lettersquared/screens/qr.dart';
import 'package:lettersquared/screens/search.dart';
import 'package:lettersquared/screens/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lettersquared/screens/userlibrary.dart';
import 'package:lettersquared/screens/start.dart';
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
      home: const StartScreen(), // test run library
      routes: {
        // Remove the root route '/'
        '/onboarding': (context) => const StartScreen(),
        '/homepage': (context) => const Homepage(),
        '/library': (context) => const Library(),
        '/search': (context) => const Search(),
        '/playingqueue': (context) => const AlbumQueuePage(),
        '/playlistView': (context) => const PlaylistViewPage(),
        '/userLibrary': (context) => const UserLibraryPage(),
        '/settings': (context) => const SettingsPage(),
        '/photo': (context) => const PhotoPage(),
      },
    );
  }
}

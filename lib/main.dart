import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lettersquared/screens/homepage.dart';
import 'package:lettersquared/screens/library.dart';
import 'package:lettersquared/screens/playingqueue.dart';
import 'package:lettersquared/screens/playlistview.dart';
import 'package:lettersquared/screens/qr.dart';
import 'package:lettersquared/screens/search.dart';
import 'package:lettersquared/screens/searchMenu.dart';
import 'package:lettersquared/screens/settings.dart';
import 'package:lettersquared/screens/trackview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lettersquared/screens/userlibrary.dart';
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
      home: Library(), //for viewing purposes only
      routes: {
        '/': (context) => const StartScreen(),
        '/onboarding': (context) => const StartScreen(),
        '/homepage': (context) => const Homepage(),
        '/library': (context) => const Library(),
        '/search': (context) => const Search(),
        '/playingQueue': (context) => const AlbumQueuePage(),
        '/playlistView': (context) => const PlaylistViewPage(),
        '/userLibrary': (context) => const UserLibraryPage(),
        '/settings': (context) => const SettingsPage(),
        '/photo': (context) => const PhotoPage(),
      },
    );
  }
}

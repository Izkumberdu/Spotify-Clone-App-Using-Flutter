import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:lettersquared/audio/song_handler.dart';
import 'package:lettersquared/provider/navbarProvider.dart';
import 'package:lettersquared/provider/song_provider.dart';
import 'package:lettersquared/screens/homepage.dart';
import 'package:lettersquared/screens/library.dart';
import 'package:lettersquared/screens/onboarding.dart';
import 'package:lettersquared/screens/playingqueue.dart';
import 'package:lettersquared/screens/playlistview.dart';
import 'package:lettersquared/screens/qr.dart';
import 'package:lettersquared/screens/search.dart';
import 'package:lettersquared/screens/searchMenu.dart';
import 'package:lettersquared/screens/settings.dart';
import 'package:lettersquared/screens/start.dart';
import 'package:lettersquared/screens/trackview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lettersquared/screens/userlibrary.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

SongHandler _songHandler = SongHandler();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  _songHandler = await AudioService.init(
      builder: () => SongHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.lettersquared.app',
        androidNotificationChannelName: 'Letter Squared',
        androidNotificationOngoing: true,
        androidShowNotificationBadge: true,
      ));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => SongProvider()..loadSongs(_songHandler)),
        ChangeNotifierProvider(create: (context) => NavbarProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartScreen(songHandler: _songHandler), // test run library
      routes: {
        // Remove the root route'/'
        '/onboarding': (context) => StartScreen(
              songHandler: _songHandler,
            ),
        '/homepage': (context) => Homepage(songHandler: _songHandler),
        '/library': (context) => const Library(),
        '/search': (context) => const Search(),
        '/searchMenu': (context) => SearchMenu(songHandler: _songHandler),
        '/playingqueue': (context) => const AlbumQueuePage(),
        '/playlistView': (context) => const PlaylistViewPage(),
        '/userLibrary': (context) => const UserLibraryPage(),
        '/settings': (context) => const SettingsPage(),
        '/photo': (context) => const PhotoPage(),
      },
    );
  }
}

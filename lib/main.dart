import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:lettersquared/audio/song_handler.dart';
import 'package:lettersquared/provider/song_provider.dart';
import 'package:lettersquared/screens/homepage.dart';
import 'package:lettersquared/screens/library.dart';
import 'package:lettersquared/screens/onboarding.dart';
import 'package:lettersquared/screens/playingqueue.dart';
import 'package:lettersquared/screens/search.dart';
import 'package:lettersquared/screens/searchMenu.dart';
import 'package:lettersquared/screens/trackview.dart';
import 'package:firebase_core/firebase_core.dart';
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
        androidNotificationChannelId: 'com.letterSquared.app',
        androidNotificationChannelName: 'Letter Squared',
        androidNotificationOngoing: true,
        androidShowNotificationBadge: true,
      ));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => SongProvider()..loadSongs(_songHandler))
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
      home: SearchMenu(songHandler: _songHandler),
      routes: {
        '/onboarding': (context) => const Onboarding(),
        // '/homepage': (context) => const Homepage(),
        '/library': (context) => const Library(),
        '/search': (context) => const Search(),
        '/playingqueue': (context) => const AlbumQueuePage(),
      },
    );
  }
}

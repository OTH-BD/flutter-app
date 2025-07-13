import 'dart:io';

import 'package:first_app/pages/chat.page.dart';
import 'package:first_app/pages/contacts.page.dart';
import 'package:first_app/pages/counter.page.dart';
import 'package:first_app/pages/gallery.page.dart';
import 'package:first_app/pages/home.page.dart';
import 'package:first_app/pages/meteo.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final envFile = File('.env');
  print('🚨 Fichier .env trouvé ? ${await envFile.exists()}');

  if (!envFile.existsSync()) {
    print('❌ Fichier .env absent ou mal placé.');
  } else {
    await dotenv.load(fileName: ".env");
  }

  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/" : (context) => HomePage(),
        "/counter" : (context) => CounterPage(),
        "/chat" : (context) => ChatPage(),
        "/contacts" : (context) => ContactsPage(),
        "/gallery" : (context) => GalleryPage(),
        "/meteo": (context) => MeteoPage(),
      },
      theme: ThemeData(
        textTheme: const TextTheme(bodyLarge: TextStyle(fontSize: 22)),
        indicatorColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.deepOrange,
        ),
      ),
    );
  }
}

import 'package:audio_journal/pages/daily_quote.dart';
import 'package:audio_journal/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          backgroundColor: Colors.white,
          textTheme: GoogleFonts.poppinsTextTheme(
            const TextTheme(
              headline1: TextStyle(fontSize: 50),
              headline2: TextStyle(fontSize: 24, color: Colors.black87),
              headline3: TextStyle(fontSize: 20, color: Colors.black87),
              headline4: TextStyle(
                  //Primary button
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
              headline5: TextStyle(
                // Secondary button
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          canvasColor: Colors.white),
      debugShowCheckedModeBanner: false,
      title: 'my voice',
      home: const DailyQuote(),
    );
  }
}

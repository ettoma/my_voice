import 'package:audio_journal/screens/splash.dart';
import 'package:audio_journal/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'utils/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); //
  // NotificationService().cancelAllNotifications();
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
          bottomSheetTheme:
              BottomSheetThemeData(backgroundColor: Colors.transparent),
          backgroundColor: Colors.white,
          textTheme: GoogleFonts.montserratTextTheme(
            const TextTheme(
              headline1: TextStyle(
                  fontSize: 32,
                  color: Color.fromRGBO(46, 48, 64, 1),
                  fontWeight: FontWeight.w500),
              headline2:
                  TextStyle(fontSize: 24, color: Color.fromRGBO(46, 48, 64, 1)),
            ),
          ),
          canvasColor: Colors.white),
      debugShowCheckedModeBanner: false,
      title: 'my voice',
      home: const Splash(),
    );
  }
}

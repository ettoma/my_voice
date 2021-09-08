import 'package:audio_journal/data/app_state.dart';
import 'package:audio_journal/pages/first_time_user.dart';
// import 'package:audio_journal/pages/daily_quote.dart';
import 'package:audio_journal/pages/recording.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences? _prefs;

  void getStoredData() async {
    _prefs = await SharedPreferences.getInstance();
    // AppState().setName(_prefs!.getString('name').toString());
    AppState().setName('ettore');
    debugPrint(AppState().userName);

    // debugPrint('Saved name: $_name');
  }

  //TODO: Save name in state to use across the app. To be implemented in Daily Quote

  @override
  void initState() {
    super.initState();
    getStoredData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (context) => AppState(),
      child: MaterialApp(
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
                  )),
            ),
            canvasColor: Colors.white),
        debugShowCheckedModeBanner: false,
        title: 'my voice',
        // home: DailyQuote(),
        // home: Recording(),
        home: const FirstTimeUser(),
      ),
    );
  }
}

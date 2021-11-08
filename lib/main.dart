import 'package:audio_journal/screens/splash.dart';
import 'package:audio_journal/utils/app_theme.dart';
import 'package:audio_journal/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); //
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
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          return MaterialApp(
            themeMode: Provider.of<ThemeProvider>(context).themeMode,
            darkTheme: AppTheme.darkTheme,
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            title: 'My voice',
            home: const Splash(),
          );
        });
  }
}

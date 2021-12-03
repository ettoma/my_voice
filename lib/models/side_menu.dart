import 'dart:io';

import 'package:audio_journal/screens/home.dart';
import 'package:audio_journal/utils/app_theme.dart';
import 'package:audio_journal/utils/notification_service.dart';
import 'package:audio_journal/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  TextEditingController controller =
      TextEditingController(text: sharedPrefs.username);
  int toggleIndexAnimation = sharedPrefs.animationPref;
  int toggleIndexNotification = sharedPrefs.notificationPref == true ? 0 : 1;
  Color? _inactiveBg() {
    if (sharedPrefs.darkThemePreference.isNotEmpty) {
      if (sharedPrefs.darkThemePreference == 'light') {
        return Colors.grey[200];
      } else if (sharedPrefs.darkThemePreference == 'dark') {
        return Colors.black.withOpacity(0.7);
      }
    } else if (sharedPrefs.darkThemePreference.isEmpty) {
      if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
        return Colors.black.withOpacity(0.7);
      } else {
        return Colors.grey[200];
      }
    }
  }

  int? _getLabelIndex() {
    if (sharedPrefs.darkThemePreference.isNotEmpty) {
      if (sharedPrefs.darkThemePreference == 'light') {
        return 0;
      } else if (sharedPrefs.darkThemePreference == 'dark') {
        return 1;
      }
    } else if (sharedPrefs.darkThemePreference.isEmpty) {
      if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? tileText = Theme.of(context).textTheme.bodyText1;
    AppLocalizations al = AppLocalizations.of(context)!;

    return Drawer(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
            child: Text(
              'my voice',
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            minVerticalPadding: 24,
            title: Text(al.editName, style: tileText),
            trailing: IconButton(
              icon: FaIcon(FontAwesomeIcons.pencilAlt,
                  color: Colors.deepOrange.withOpacity(0.7)),
              onPressed: () async {
                Platform.isIOS
                    ? iosModal(context, controller)
                    : androidModal(context, controller);
              },
            ),
          ),
          ListTile(
            minVerticalPadding: 24,
            title: Text(al.illustration, style: tileText),
            trailing: ToggleSwitch(
              minWidth: 35.0,
              minHeight: 35,
              cornerRadius: 20.0,
              activeBgColors: [
                const [Color.fromRGBO(238, 123, 130, 1)],
                [Colors.purple[300]!]
              ],
              activeFgColor: Colors.white,
              inactiveBgColor: _inactiveBg(),
              inactiveFgColor: sharedPrefs.darkThemePreference == 'light'
                  ? Colors.grey[200]
                  : Colors.grey[500],
              initialLabelIndex: toggleIndexAnimation,
              totalSwitches: 2,
              customIcons: const [
                Icon(FontAwesomeIcons.mars, size: 15, color: Colors.white),
                Icon(FontAwesomeIcons.venus, size: 15, color: Colors.white)
              ],
              radiusStyle: true,
              onToggle: (index) {
                setState(
                  () {
                    toggleIndexAnimation = index;
                  },
                );
                sharedPrefs.animationPref = index;
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return const Home();
                }));
              },
            ),
          ),
          ListTile(
              minVerticalPadding: 24,
              title: Text(al.notifications, style: tileText),
              trailing: ToggleSwitch(
                totalSwitches: 2,
                minWidth: 35.0,
                minHeight: 35,
                cornerRadius: 20.0,
                activeBgColors: [
                  [Colors.teal[800]!],
                  [Colors.brown[300]!]
                ],
                activeFgColor: Colors.white,
                inactiveBgColor: _inactiveBg(),
                inactiveFgColor: sharedPrefs.darkThemePreference == 'light'
                    ? Colors.grey[200]
                    : Colors.grey[500],
                customIcons: const [
                  Icon(FontAwesomeIcons.bell, size: 15, color: Colors.white),
                  Icon(FontAwesomeIcons.bellSlash,
                      size: 15, color: Colors.white)
                ],
                initialLabelIndex: toggleIndexNotification,
                radiusStyle: true,
                onToggle: (index) {
                  setState(() {
                    toggleIndexNotification = index;
                  });
                  sharedPrefs.notificationPref = index == 0 ? true : false;
                  if (index == 0) {
                    NotificationService().scheduleDailyNotification();
                  } else if (index == 1) {
                    NotificationService().cancelAllNotifications();
                  }
                },
              )),
          ListTile(
              minVerticalPadding: 24,
              title: Text(al.darkMode, style: tileText),
              trailing: ToggleSwitch(
                totalSwitches: 2,
                minWidth: 35.0,
                minHeight: 35,
                cornerRadius: 20.0,
                activeBgColors: [
                  [Colors.yellow[800]!],
                  [Colors.blue[300]!]
                ],
                activeFgColor: Colors.white,
                inactiveBgColor: _inactiveBg(),
                inactiveFgColor: sharedPrefs.darkThemePreference == 'light'
                    ? Colors.grey[200]
                    : Colors.grey[500],
                customIcons: const [
                  Icon(FontAwesomeIcons.lightbulb,
                      size: 15, color: Colors.white),
                  Icon(FontAwesomeIcons.moon, size: 15, color: Colors.white)
                ],
                initialLabelIndex: _getLabelIndex()!,
                radiusStyle: true,
                onToggle: (index) {
                  final provider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  provider.toggleMode(index == 0 ? false : true);
                  sharedPrefs.darkThemePreference =
                      index == 0 ? 'light' : 'dark';
                  setState(() {});
                },
              )),
        ],
      ),
    ));
  }
}

Future<dynamic> iosModal(context, controller) async {
  AppLocalizations al = AppLocalizations.of(context)!;
  return await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoTheme(
          data: CupertinoThemeData(
              brightness: ThemeProvider().isDarkMode
                  ? Brightness.dark
                  : Brightness.light),
          child: CupertinoAlertDialog(
            title: Text(al.enterName),
            content: CupertinoTextField(
              controller: controller,
              maxLength: 18,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
            ),
            actions: [
              CupertinoDialogAction(
                  onPressed: () {
                    sharedPrefs.username = controller.text.trim();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const Home();
                    }));
                  },
                  child: const FaIcon(FontAwesomeIcons.check))
            ],
          ),
        );
      });
}

Future<dynamic> androidModal(context, controller) async {
  AppLocalizations al = AppLocalizations.of(context)!;
  return await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            color: ThemeProvider().isDarkMode ? Colors.grey[800] : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    al.enterName,
                    style: TextStyle(
                        color: ThemeProvider().isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      decoration: InputDecoration(
                          counterStyle: TextStyle(
                              color: ThemeProvider().isDarkMode
                                  ? Colors.white
                                  : Colors.black)),
                      controller: controller,
                      maxLength: 18,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      style: TextStyle(
                          color: ThemeProvider().isDarkMode
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        sharedPrefs.username = controller.text.trim();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return const Home();
                        }));
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.check,
                        color: Colors.blueAccent,
                      ))
                ],
              ),
            ),
          ),
        );
      });
}

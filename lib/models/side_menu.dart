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

  @override
  Widget build(BuildContext context) {
    TextStyle? tileText = Theme.of(context).textTheme.bodyText1;

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
            title: Text('Edit name', style: tileText),
            trailing: IconButton(
              icon: FaIcon(FontAwesomeIcons.pencilAlt,
                  color: Colors.deepOrange.withOpacity(0.7)),
              onPressed: () async {
                await showCupertinoModalPopup(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text('Enter a name'),
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
                      );
                    });
              },
            ),
          ),
          ListTile(
            minVerticalPadding: 24,
            title: Text('Illustration', style: tileText),
            trailing: ToggleSwitch(
              minWidth: 35.0,
              minHeight: 35,
              cornerRadius: 20.0,
              activeBgColors: [
                const [Color.fromRGBO(238, 123, 130, 1)],
                [Colors.purple[300]!]
              ],
              activeFgColor: Colors.white,
              inactiveBgColor: sharedPrefs.darkThemePreference == 'light'
                  ? Colors.grey[200]
                  : Colors.black.withOpacity(0.7),
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
              title: Text('Notifications', style: tileText),
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
                inactiveBgColor: sharedPrefs.darkThemePreference == 'light'
                    ? Colors.grey[200]
                    : Colors.black.withOpacity(0.7),
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
                    NotificationService().cancelAllNotifications();
                  } else if (index == 1) {
                    NotificationService().scheduleDailyNotification();
                  }
                },
              )),
          ListTile(
              minVerticalPadding: 24,
              title: Text('Dark mode', style: tileText),
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
                inactiveBgColor: sharedPrefs.darkThemePreference == 'light'
                    ? Colors.grey[200]
                    : Colors.black.withOpacity(0.7),
                inactiveFgColor: sharedPrefs.darkThemePreference == 'light'
                    ? Colors.grey[200]
                    : Colors.grey[500],
                customIcons: const [
                  Icon(FontAwesomeIcons.lightbulb,
                      size: 15, color: Colors.white),
                  Icon(FontAwesomeIcons.moon, size: 15, color: Colors.white)
                ],
                initialLabelIndex:
                    Provider.of<ThemeProvider>(context).isDarkMode ? 1 : 0,
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

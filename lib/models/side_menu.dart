import 'package:audio_journal/screens/home.dart';
import 'package:audio_journal/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  TextEditingController controller =
      TextEditingController(text: sharedPrefs.username);
  int toggleIndex = sharedPrefs.animationPref;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
      child: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
            child: Text(
              'my voice',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ),
          ListTile(
            title: const Text('Edit name'),
            trailing: IconButton(
              icon: const FaIcon(FontAwesomeIcons.pen),
              onPressed: () async {
                await showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: const Text('Enter a name'),
                        content: CupertinoTextField(controller: controller),
                        actions: [
                          CupertinoDialogAction(
                              onPressed: () {
                                sharedPrefs.username = controller.text;
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
            title: Text('Change illustration'),
            trailing: ToggleSwitch(
              minWidth: 35.0,
              minHeight: 35,
              cornerRadius: 20.0,
              activeBgColors: [
                [Colors.green[400]!],
                [Colors.red[300]!]
              ],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey[200],
              inactiveFgColor: Colors.white,
              initialLabelIndex: toggleIndex,
              totalSwitches: 2,
              customIcons: const [
                Icon(FontAwesomeIcons.mars, size: 15, color: Colors.white),
                Icon(FontAwesomeIcons.venus, size: 15, color: Colors.white)
              ],
              radiusStyle: true,
              onToggle: (index) {
                setState(
                  () {
                    toggleIndex = index;
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
            title: Text('disable notifications'),
          ),
          ListTile(
            title: Text('dark mode'),
          )
        ],
      ),
    ));
  }
}

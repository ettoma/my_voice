import 'package:audio_journal/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  TextEditingController controller =
      TextEditingController(text: sharedPrefs.username);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        Text('Hello ${sharedPrefs.username}'),
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
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            child: const FaIcon(FontAwesomeIcons.check))
                      ],
                    );
                  });
            },
          ),
        ),
        ListTile(title: Text('Change illustration')),
        ListTile(
          title: Text('disable notifications'),
        )
      ],
    ));
  }
}

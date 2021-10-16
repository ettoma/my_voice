import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/models/sound_recorder.dart';
import 'package:audio_journal/screens/audio_player.dart';
import 'package:audio_journal/screens/first_time_user.dart';
import 'package:audio_journal/screens/record_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool selected = false;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      if (SoundRecorder.isRecording != true) {
        setState(() {
          _selectedIndex = index;
        });
      }
    }

    return Scaffold(
      appBar: appBar(context),
      // body: FirstTimeUser(),
      body: _selectedIndex == 0 ? const RecordScreen() : const AudioPlayer(),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.red.shade300,
        unselectedItemColor: Colors.grey.withOpacity(0.75),
        items: const [
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.itunesNote), label: 'Play')
        ],
      ),
    );
  }
}

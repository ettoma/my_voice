import 'package:audio_journal/models/app_bar.dart';
import 'package:audio_journal/pages/audio_player.dart';
import 'package:audio_journal/pages/recording.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const Text(
              'Take 10 seconds for yourself',
              style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Gill Sans'),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.blue,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const Recording();
                              }));
                            },
                            icon: const FaIcon(FontAwesomeIcons.penAlt)),
                        const Text('Record'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const AudioPlayer();
                              }));
                            },
                            icon: const FaIcon(FontAwesomeIcons.bookOpen)),
                        const Text('Play')
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

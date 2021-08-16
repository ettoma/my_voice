// import 'package:audio_journal/models/app_bar.dart';
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
      // appBar: appBar(),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 34.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const Recording();
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                'record',
                                style: TextStyle(
                                    color: Color.fromRGBO(70, 108, 132, 1),
                                    fontSize: 58,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const FaIcon(FontAwesomeIcons.arrowRight))
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AudioPlayer();
                            }));
                          },
                          child: const Text('all recordings',
                              style: TextStyle(
                                  color: Color.fromRGBO(141, 150, 155, 1),
                                  fontSize: 32)),
                        )
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

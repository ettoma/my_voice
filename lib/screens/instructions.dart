import 'package:audio_journal/screens/home.dart';
import 'package:flutter/material.dart';

class Instructions extends StatelessWidget {
  const Instructions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Put your thoughts into words, 10 seconds a day, and slowly build a lifetime diary.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 21),
              ),
              const SizedBox(height: 24),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const Home();
                        },
                      ),
                    );
                  },
                  child:
                      const Text('Get started', style: TextStyle(fontSize: 18)))
            ],
          ),
        ),
      ),
    );
  }
}

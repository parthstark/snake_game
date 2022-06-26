import 'package:flutter/material.dart';
import 'package:snake_king/screens/scores_screen.dart';
import 'game_screen.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(),
                const Text("SNAKE\nKING",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontFamily: 'Girassol', color: Colors.white),
                    textScaleFactor: 7),
                const SizedBox(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Game(),
                      ),
                    );
                  },
                  child: const Text(
                    "PLAY",
                    style:
                        TextStyle(fontFamily: 'Girassol', color: Colors.white),
                    textScaleFactor: 3,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const DeviceScores(),
                      ),
                    );
                  },
                  child: const Text(
                    "High Score",
                    style:
                        TextStyle(fontFamily: 'Girassol', color: Colors.white),
                    textScaleFactor: 2,
                  ),
                ),
                const Image(
                  image: AssetImage('assets/images/snake.png'),
                  height: 300,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

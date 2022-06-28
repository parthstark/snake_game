import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snake_king/utils/db_helper.dart';
import 'dart:async';
import 'dart:math';

import '../models/high_score.dart';
import 'home_screen.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  // constructor
  _GameState() {
    direction = 'down';
    startGame();
  }

  List<int> snakePos = [25, 45, 65];
  final int _axiscount = 20;
  late int _count;
  static var randomNumber = Random();
  int food = randomNumber.nextInt(760);
  var direction = 'down';

  @override
  Widget build(BuildContext context) {
    _count = (MediaQuery.of(context).size.height - 100) ~/ 20 * 20;
    return Scaffold(
      backgroundColor: Colors.teal[900],
      body: WillPopScope(
        onWillPop: backButton,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 50,
                child: Center(
                  child: Text('Score: ' + (snakePos.length - 3).toString(),
                      style: const TextStyle(
                          fontFamily: 'Girassol', color: Colors.white),
                      textScaleFactor: 3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (direction != 'up' && details.delta.dy > 0) {
                      direction = 'down';
                    } else if (direction != 'down' && details.delta.dy < 0) {
                      direction = 'up';
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (direction != 'left' && details.delta.dx > 0) {
                      direction = 'right';
                    } else if (direction != 'right' && details.delta.dx < 0) {
                      direction = 'left';
                    }
                  },
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _count,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _axiscount),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == food) {
                        return Padding(
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.red,
                              ),
                            ));
                      }
                      if (snakePos.contains(index)) {
                        return Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startGame() {
    snakePos = [25, 45, 65];
    const duration = Duration(milliseconds: 200);
    Timer.periodic(
      duration,
      (timer) {
        updateSnake();
        if (gameOver()) {
          timer.cancel();
          _showGameOverScreen();
        }
      },
    );
  }

  void generateFood() {
    food = randomNumber.nextInt(_count);
  }

  void updateSnake() {
    if (mounted) {
      setState(
        () {
          switch (direction) {
            case 'down':
              snakePos.last > (_count - _axiscount)
                  ? snakePos.add(snakePos.last + _axiscount - _count)
                  : snakePos.add(snakePos.last + _axiscount);
              break;
            case 'up':
              snakePos.last < _axiscount
                  ? snakePos.add(snakePos.last - _axiscount + _count)
                  : snakePos.add(snakePos.last - _axiscount);
              break;
            case 'left':
              snakePos.last % _axiscount == 0
                  ? snakePos.add(snakePos.last - 1 + _axiscount)
                  : snakePos.add(snakePos.last - 1);
              break;
            case 'right':
              (snakePos.last + 1) % _axiscount == 0
                  ? snakePos.add(snakePos.last + 1 - _axiscount)
                  : snakePos.add(snakePos.last + 1);
              break;
            default:
          }
          if (snakePos.last == food) {
            generateFood();
          } else {
            snakePos.removeAt(0);
          }
        },
      );
    }
  }

  bool gameOver() {
    for (int i = 0; i < snakePos.length; i++) {
      int count = 0;
      for (int j = i + 1; j < snakePos.length; j++) {
        if (snakePos[i] == snakePos[j]) {
          count++;
        }
      }
      if (count != 0) {
        return true;
      }
    }
    return false;
  }

  void _showGameOverScreen() async {
    int currScore = snakePos.length - 3;
    final scoreObject =
        Score(currScore, DateFormat('yMMMMd').format(DateTime.now()));
    await DatabaseHelper.instance.create(scoreObject);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over',
              textScaleFactor: 2, style: TextStyle(fontFamily: 'Girassol')),
          content: Text('Your score: ' + (scoreObject.score).toString(),
              style: const TextStyle(fontFamily: 'Girassol')),
          actions: [
            TextButton(
              onPressed: () {
                direction = 'down';
                startGame();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Play Again',
                style: TextStyle(color: Colors.teal),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Home(),
                  ),
                );
              },
              child: const Text(
                'Exit',
                style: TextStyle(color: Colors.teal),
              ),
            )
          ],
        );
      },
    );
  }

  Future<bool> backButton() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Do you want to exit?',
            textScaleFactor: 1.3,
            style: TextStyle(fontFamily: 'Girassol'),
          ),
          actions: [
            TextButton(
              child: const Text('No', style: TextStyle(color: Colors.teal)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes', style: TextStyle(color: Colors.teal)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Home(),
                  ),
                );
              },
            )
          ],
        );
      },
    );
    return Future.value(true);
  }
}

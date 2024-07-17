import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../constants/const.dart';
import '../models/pac.dart';
import '../models/pink_ghost.dart';
import '../models/red_ghost.dart';
import '../models/yellow_ghost.dart';
import '../widgets/path.dart';
import '../widgets/pixel.dart';
// import 'package:audioplayers/audioplayers.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int numberInRow = 11;
  static const int numberOfSquares = numberInRow * 16;
  int pac = numberInRow * 14 + 1;
  int red = numberInRow * 2 - 2;
  int yellow = numberInRow * 9 - 1;
  int pink = numberInRow * 11 - 2;
  List<int> snacks = [];
  bool preGame = true;
  bool mouthClosed = false;
  int score = 0;
  bool paused = false;

  // AudioPlayer advancedPlayer1 = AudioPlayer();
  // AudioPlayer advancedPlayer2 = AudioPlayer();
  // AudioCache audioInGame = AudioCache(prefix: 'assets/sounds/');
  // AudioCache audioInMunch = AudioCache(prefix: 'assets/sounds/');
  // AudioCache audioInDeath = AudioCache(prefix: 'assets/sounds/');
  // AudioCache audioPaused = AudioCache(prefix: 'assets/sounds/');

  String direction = 'right';
  String ghostLast1 = 'left';
  String ghostLast2 = 'left';
  String ghostLast3 = 'down';
  final Random random = Random();

  @override
  void initState() {
    eatSnack();
    super.initState();
  }

  void eatSnack() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!Constants.barriers.contains(i)) {
        snacks.add(i);
      }
    }
  }

  void startGame() {
    if (preGame) {
      // advancedPlayer1 = new AudioPlayer();
      // audioInGame = new AudioCache(fixedPlayer: advancedPlayer1);
      // audioPaused = new AudioCache(fixedPlayer: advancedPlayer2);
      // audioInGame.loop('pacman_beginning.wav');
      preGame = false;
      eatSnack();

      Timer.periodic(const Duration(milliseconds: 10), (timer) {
        if (paused) {
        } else {
          // advancedPlayer1.resume();
        }
        if (pac == red || pac == yellow || pac == pink) {
          // advancedPlayer1.stop();
          // audioInDeath.play('pacman_death.wav');
          setState(() {
            pac = -1;
          });
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.black,
                  title: const Text(
                    'Game Over!',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Text(
                    'Score: $score',
                    style: const TextStyle(color: Colors.white),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        // audioInGame.loop('pacman_beginning.wav');
                        setState(() {
                          pac = numberInRow * 14 + 1;
                          red = numberInRow * 2 - 2;
                          yellow = numberInRow * 9 - 1;
                          pink = numberInRow * 11 - 2;
                          paused = false;
                          preGame = false;
                          mouthClosed = false;
                          direction = 'right';
                          snacks.clear();
                          eatSnack();
                          score = 0;
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green, Colors.blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'Play Again',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                );
              });
        }
      });
      Timer.periodic(const Duration(milliseconds: 190), (timer) {
        if (!paused) {
          moveRed();
          movePink();
          moveYellow();
        }
      });
      Timer.periodic(const Duration(milliseconds: 170), (timer) {
        setState(() {
          mouthClosed = !mouthClosed;
        });
        if (snacks.contains(pac)) {
          // audioInMunch.play('pacman_munch.wav');
          setState(() {
            snacks.remove(pac);
          });
          score++;
        }

        switch (direction) {
          case 'left':
            if (!paused) moveLeft();
            break;
          case 'right':
            if (!paused) moveRight();
            break;
          case 'up':
            if (!paused) moveUp();
            break;
          case 'down':
            if (!paused) moveDown();
            break;
        }
      });
    }
  }

  void moveLeft() {
    if (!Constants.barriers.contains(pac - 1)) {
      setState(() {
        pac = pac - 1;
      });
    }
  }

  void moveRight() {
    if (!Constants.barriers.contains(pac + 1)) {
      setState(() {
        pac = pac + 1;
      });
    }
  }

  void moveUp() {
    if (!Constants.barriers.contains(pac - numberInRow)) {
      setState(() {
        pac = pac - numberInRow;
      });
    }
  }

  void moveDown() {
    if (!Constants.barriers.contains(pac + numberInRow)) {
      setState(() {
        pac = pac + numberInRow;
      });
    }
  }

  List<String> getPossibleDirections(int currentIndex) {
    List<String> possibleDirections = [];
    if (!Constants.barriers.contains(currentIndex - 1))
      possibleDirections.add('left');
    if (!Constants.barriers.contains(currentIndex + 1))
      possibleDirections.add('right');
    if (!Constants.barriers.contains(currentIndex - numberInRow))
      possibleDirections.add('up');
    if (!Constants.barriers.contains(currentIndex + numberInRow))
      possibleDirections.add('down');
    return possibleDirections;
  }

  void moveRed() {
    List<String> possibleDirections = getPossibleDirections(red);
    if (possibleDirections.isNotEmpty) {
      ghostLast1 =
          possibleDirections[random.nextInt(possibleDirections.length)];
      switch (ghostLast1) {
        case 'left':
          setState(() => red -= 1);
          break;
        case 'right':
          setState(() => red += 1);
          break;
        case 'up':
          setState(() => red -= numberInRow);
          break;
        case 'down':
          setState(() => red += numberInRow);
          break;
      }
    }
  }

  void moveYellow() {
    List<String> possibleDirections = getPossibleDirections(yellow);
    if (possibleDirections.isNotEmpty) {
      ghostLast2 =
          possibleDirections[random.nextInt(possibleDirections.length)];
      switch (ghostLast2) {
        case 'left':
          setState(() => yellow -= 1);
          break;
        case 'right':
          setState(() => yellow += 1);
          break;
        case 'up':
          setState(() => yellow -= numberInRow);
          break;
        case 'down':
          setState(() => yellow += numberInRow);
          break;
      }
    }
  }

  void movePink() {
    List<String> possibleDirections = getPossibleDirections(pink);
    if (possibleDirections.isNotEmpty) {
      ghostLast3 =
          possibleDirections[random.nextInt(possibleDirections.length)];
      switch (ghostLast3) {
        case 'left':
          setState(() => pink -= 1);
          break;
        case 'right':
          setState(() => pink += 1);
          break;
        case 'up':
          setState(() => pink -= numberInRow);
          break;
        case 'down':
          setState(() => pink += numberInRow);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 5, // Adjusted flex to give more space to the GridView
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  direction = 'down';
                } else if (details.delta.dy < 0) {
                  direction = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  direction = 'right';
                } else if (details.delta.dx < 0) {
                  direction = 'left';
                }
              },
              child: GridView.builder(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: numberOfSquares,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: numberInRow,
                ),
                itemBuilder: (BuildContext context, int index) {
                  if (mouthClosed && pac == index) {
                    return Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.yellow, shape: BoxShape.circle),
                      ),
                    );
                  } else if (pac == index) {
                    switch (direction) {
                      case 'left':
                        return Transform.rotate(
                            angle: pi, child: const Pacman());
                      case 'right':
                        return const Pacman();
                      case 'up':
                        return Transform.rotate(
                            angle: 3 * pi / 2, child: const Pacman());
                      case 'down':
                        return Transform.rotate(
                            angle: pi / 2, child: const Pacman());
                      default:
                        return const Pacman();
                    }
                  } else if (red == index) {
                    return const Red();
                  } else if (yellow == index) {
                    return const Yellow();
                  } else if (pink == index) {
                    return const Pink();
                  } else if (Constants.barriers.contains(index)) {
                    return Pixel(
                      innerColor: Colors.green[900],
                      outerColor: Colors.green[800],
                    );
                  } else if (preGame && snacks.contains(index)) {
                    return const MovePath(
                      innerColor: Colors.yellow,
                      outerColor: Colors.black,
                    );
                  } else {
                    return const Pixel(
                      innerColor: Colors.black,
                      outerColor: Colors.black,
                    );
                  }
                },
              ),
            ),
          ),
          Expanded(
            flex:
                1, // Adjusted flex to give space for the score and play button
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Score: $score',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                GestureDetector(
                  onTap: startGame,
                  child: const Text(
                    'P L A Y',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                if (!paused)
                  GestureDetector(
                    child: const Icon(
                      Icons.pause,
                      color: Colors.white,
                    ),
                    onTap: () => {
                      setState(() {
                        paused = !paused;
                      }),
                    },
                  ),
                if (paused)
                  GestureDetector(
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onTap: () => {
                      setState(() {
                        paused = !paused;
                      }),
                    },
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

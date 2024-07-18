import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/const.dart';
import '../models/pac.dart';
import '../models/pink_ghost.dart';
import '../models/red_ghost.dart';
import '../models/yellow_ghost.dart';
import '../widgets/path.dart';
import '../widgets/pixel.dart';

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
  int level = 1;
  List<int> extraGhosts = [];
  List<String> extraGhostDirections = [];
  List<Widget> extraGhostTypes = [];

  late AudioPlayer _audioPlayer;
  late AudioCache _audioCache;

  String direction = 'right';
  String ghostLast1 = 'left';
  String ghostLast2 = 'left';
  String ghostLast3 = 'down';
  final Random random = Random();

  @override
  void initState() {
    eatSnack();
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  void eatSnack() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!Constants.barriers.contains(i)) {
        snacks.add(i);
      }
    }
  }

  Future<void> startGame() async {
    if (preGame) {
      await _audioPlayer.play(AssetSource('sounds/pacman_beginning.wav'));
      preGame = false;
      eatSnack();

      Timer.periodic(const Duration(milliseconds: 10), (timer) {
        if (paused) {
        } else {
        }
        if (pac == red ||
            pac == yellow ||
            pac == pink ||
            extraGhosts.contains(pac)) {
          _audioPlayer.play(AssetSource('sounds/pacman_death.wav'));
          setState(() {
            pac = -1;
          });
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  child: AlertDialog(
                    backgroundColor: Colors.black,
                    title: Text(
                      'Game Over!',
                      style: GoogleFonts.sourceCodePro(
                          color: Colors.white, fontSize: 28, letterSpacing: 2),
                    ),
                    content: Text(
                      'Score: $score',
                      style: GoogleFonts.sourceCodePro(
                          color: Colors.white, letterSpacing: 1),
                    ),
                    actions: [
                      GestureDetector(
                        onTap: () {
                          _audioPlayer.play(AssetSource('sounds/pacman_beginning.wav'));
                          setState(() {
                            resetGame();
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white,
                                width: 1), // White border color
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Play Again',
                            style: GoogleFonts.sourceCodePro(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
        }
      });
      Timer.periodic(const Duration(milliseconds: 190), (timer) {
        if (!paused) {
          moveRed();
          movePink();
          moveYellow();
          moveExtraGhosts();
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
            score++;
          });
          if (snacks.isEmpty) {
            levelUp();
          }
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

  void resetGame() {
    pac = numberInRow * 14 + 1;
    red = numberInRow * 2 - 2;
    yellow = numberInRow * 9 - 1;
    pink = numberInRow * 11 - 2;
    extraGhosts.clear();
    extraGhostDirections.clear();
    extraGhostTypes.clear();
    paused = false;
    preGame = false;
    mouthClosed = false;
    direction = 'right';
    snacks.clear();
    eatSnack();
    score = 0;
    level = 1;
  }

  void levelUp() {
    setState(() {
      level++;
      eatSnack();
      addExtraGhost();
    });
  }

  void addExtraGhost() {
    int newGhostPosition = numberInRow * (level + 1) - 1;
    extraGhosts.add(newGhostPosition);
    extraGhostDirections.add('left');

    List<Widget> ghostTypes = [const Red(), const Yellow(), const Pink()];
    Widget randomGhost = ghostTypes[random.nextInt(ghostTypes.length)];
    extraGhostTypes.add(randomGhost);
  }

  void moveExtraGhosts() {
    for (int i = 0; i < extraGhosts.length; i++) {
      List<String> possibleDirections = getPossibleDirections(extraGhosts[i]);
      if (possibleDirections.isNotEmpty) {
        extraGhostDirections[i] =
            possibleDirections[random.nextInt(possibleDirections.length)];
        switch (extraGhostDirections[i]) {
          case 'left':
            setState(() => extraGhosts[i] -= 1);
            break;
          case 'right':
            setState(() => extraGhosts[i] += 1);
            break;
          case 'up':
            setState(() => extraGhosts[i] -= numberInRow);
            break;
          case 'down':
            setState(() => extraGhosts[i] += numberInRow);
            break;
        }
      }
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
                  } else if (extraGhosts.contains(index)) {
                    int ghostIndex = extraGhosts.indexOf(index);
                    return extraGhostTypes[ghostIndex];
                  } else if (Constants.barriers.contains(index)) {
                    return Pixel(
                      innerColor: Colors.green[900],
                      outerColor: Colors.green[800],
                    );
                  } else if (snacks.contains(index)) {
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
            child: Container(
              padding: const EdgeInsets.only(
                  bottom: 10,
                  right: 8,
                  left: 8), // Add padding around the border
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white, width: 2), // White border color
                borderRadius:
                    BorderRadius.circular(10), // Circular radius of 10
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'L E V E L 0$level',
                        style: GoogleFonts.sourceCodePro(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'SCORE : $score',
                        style: GoogleFonts.sourceCodePro(
                            color: Colors.white,
                            fontSize: 12,
                            letterSpacing: 1),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (preGame || paused) {
                            startGame();
                          } else {
                            setState(() {
                              paused = !paused;
                            });
                          }
                        },
                        child: Text(
                          preGame || paused ? 'PLAY' : 'PAUSE',
                          style: GoogleFonts.sourceCodePro(
                            color: Colors.white,
                            fontSize: 22,
                            letterSpacing: 5,
                            fontWeight: FontWeight.bold,
                          ),
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
                                }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

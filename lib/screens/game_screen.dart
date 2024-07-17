import 'package:flutter/material.dart';
import 'package:pacman/constants/const.dart';
import 'package:pacman/widgets/path.dart';
import 'package:pacman/widgets/pixel.dart';

import '../models/pac.dart';
import '../models/pink_ghost.dart';
import '../models/red_ghost.dart';
import '../models/yellow_ghost.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int numberInRow = 11;
  static const int numberOfSquares = numberInRow * 16;
  int pac = numberInRow * 14 + 1;
  int red = numberInRow * 2-2;
  int yellow = numberInRow * 9-1;
  int pink = numberInRow * 11-2;
  List<int> snacks = [];
  bool preGame = true;

  @override
  void initState() {
    // TODO: implement initState
    eatSnack();
    super.initState();
  }

  void eatSnack(){
    for (int i = 0; i < numberOfSquares; i++){
      if(!Constants.barriers.contains(i)){
        snacks.add(i);
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
            flex: 1,
            child: GridView.builder(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: numberOfSquares,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: numberInRow,
              ),
              itemBuilder: (BuildContext context, int index) {
               if (pac == index) {
                  return const Pacman();
               } else if(red == index) {
                  return const Red();
               } else if(yellow == index) {
                  return const Yellow();
               } else if(pink == index) {
                  return const Pink();
               }
               else if (Constants.barriers.contains(index)) {
                  return Pixel(
                    innerColor: Colors.green[900],
                    outerColor: Colors.green[800],
                  );
                } else if (preGame && snacks.contains(index)){
                  return const MovePath(
                    innerColor: Colors.yellow,
                    outerColor: Colors.black,
                  );
               }else {
                  return const Pixel(
                    innerColor: Colors.black,
                    outerColor: Colors.black,
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

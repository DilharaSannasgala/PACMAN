import 'package:flutter/material.dart';
import 'package:pacman/constants/const.dart';
import 'package:pacman/widgets/pixel.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int numberInRow = 11;
  static const int numberOfSquares = numberInRow * 16;

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
                if (Constants.barriers.contains(index)) {
                  return Pixel(
                    innerColor: Colors.green[900],
                    outerColor: Colors.green[800],
                  );
                } else {
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

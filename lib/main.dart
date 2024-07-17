import 'package:flutter/material.dart';
import 'package:pacman/screens/game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'PACMAN',
      home: GameScreen(),
    );
  }
}

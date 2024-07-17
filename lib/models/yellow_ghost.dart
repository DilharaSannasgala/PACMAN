import 'package:flutter/material.dart';

class Yellow extends StatelessWidget{
  const Yellow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Image.asset(
        'assets/images/YELLOW.gif',
      ),
    );
  }
}
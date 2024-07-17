import 'package:flutter/material.dart';

class Pink extends StatelessWidget{
  const Pink({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Image.asset(
        'assets/images/PINK.gif',
      ),
    );
  }
}
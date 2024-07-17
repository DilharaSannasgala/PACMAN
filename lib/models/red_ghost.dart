import 'package:flutter/material.dart';

class Red extends StatelessWidget{
  const Red({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Image.asset(
        'assets/images/RED.gif',
      ),
    );
  }
}
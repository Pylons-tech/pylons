import 'package:flutter/material.dart';

class TextDisplay extends StatelessWidget {
  final String text;

  const TextDisplay({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 42, color: Colors.white, backgroundColor: Colors.black45));
  }
}
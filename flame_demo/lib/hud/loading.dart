import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      color: Colors.grey,
      child: const Center(child: Text("Please wait...", style: TextStyle(color: Colors.white))),
    ));
  }
}
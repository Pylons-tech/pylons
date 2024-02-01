import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      color: Colors.black12,
      child: const Center(child: Text("Please wait...", style: TextStyle(color: Colors.white))),
    ));
  }
}
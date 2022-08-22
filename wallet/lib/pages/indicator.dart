import 'package:flutter/material.dart';

class Indicator extends AnimatedWidget {
  final PageController controller;
  const Indicator({required this.controller}) : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return _createIndicator(index);
                })
          ],
        ),
      ),
    );
  }

  Widget _createIndicator(index) {
    var w = 10.0;
    var h = 10.0;
    var color = Colors.grey;

    if (controller.page == index) {
      color = Colors.blueGrey;
      h = 13.0;
      w = 13.0;
    }

    return SizedBox(
      height: 26,
      width: 26,
      child: Center(
        child: AnimatedContainer(
          margin: const EdgeInsets.all(5),
          color: color,
          width: w,
          height: h,
          duration: const Duration(milliseconds: 100),
        ),
      ),
    );
  }
}

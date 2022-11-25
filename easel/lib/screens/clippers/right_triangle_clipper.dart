import 'package:flutter/material.dart';

enum Orientation {
  orientationSE,
  orientationNE,
  orientationNW,
  orientationSW,
}

class RightTriangleClipper extends CustomClipper<Path> {
  final Orientation orientation;

  RightTriangleClipper({required this.orientation});

  @override
  Path getClip(Size size) {
    final path = Path();

    switch (orientation) {
      case Orientation.orientationSW:
        path.lineTo(size.width, size.height);
        path.lineTo(size.width, 0);
        break;
      case Orientation.orientationSE:
        path.lineTo(0, size.height);
        path.lineTo(size.width, 0);
        break;
      case Orientation.orientationNW:
        path.moveTo(size.width, 0);
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        break;
      case Orientation.orientationNE:
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        break;
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return oldClipper != this;
  }
}

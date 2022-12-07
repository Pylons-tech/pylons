import 'package:flutter/material.dart';

class LeftRightTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path0 = Path();
    path0.moveTo(0, size.height);
    path0.lineTo(0, size.height * 0.0714000);
    path0.lineTo(size.width * 0.0452000, 0);
    path0.lineTo(size.width * 0.9579000, size.height * 0.0004000);
    path0.lineTo(size.width, size.height * 0.0713000);
    path0.lineTo(size.width, size.height);
    path0.lineTo(0, size.height);
    path0.close();

    return path0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

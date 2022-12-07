import 'package:flutter/material.dart';

class TopLeftBottomRightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path0 = Path();
    path0.moveTo(size.width * 0.0583000, 0);
    path0.lineTo(size.width, 0);
    path0.lineTo(size.width, size.height * 0.6969000);
    path0.lineTo(size.width * 0.9475000, size.height);
    path0.lineTo(0, size.height);
    path0.lineTo(0, size.height * 0.3014000);
    path0.lineTo(size.width * 0.0583000, 0);
    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

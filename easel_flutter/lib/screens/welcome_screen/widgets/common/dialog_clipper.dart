
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width - 65.h, size.height);
    path.lineTo(size.width, size.height - 65.h);
    path.lineTo(size.width, 0);
    path.lineTo(65.h, 0);
    path.lineTo(0, 65.h);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

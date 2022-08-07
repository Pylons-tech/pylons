import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/cupertino.dart';

class DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final point1 = Offset(-0.5, size.height - 1);
    final point2 = Offset(size.width, 0);
    final paint = Paint()
      ..color = EaselAppTheme.kBlack
      ..strokeWidth = 2;
    canvas.drawLine(point1, point2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
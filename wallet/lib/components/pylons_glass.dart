import 'dart:ui';
import 'package:flutter/material.dart';

class GlassMorphism extends StatelessWidget {
  final Widget child;
  final Color startColor;
  final Color endColor;
  final double startOpacity;
  final double endOpacity;
  final double borderRadius;
  final double blurLevel;

  const GlassMorphism(
      {Key? key,
      required this.child,
      required this.startColor,
      required this.startOpacity,
      required this.endColor,
      required this.endOpacity,
      this.borderRadius = 0,
      required this.blurLevel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurLevel, sigmaY: blurLevel),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                startColor.withOpacity(startOpacity),
                endColor.withOpacity(endOpacity),
              ],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        ),
      ),
    );
  }
}

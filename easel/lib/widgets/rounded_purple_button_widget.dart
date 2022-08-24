import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/material.dart';

class RoundedPurpleButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String icon;

  const RoundedPurpleButtonWidget(
      {Key? key, required this.onPressed, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: EaselAppTheme.kBlue.withOpacity(0.6),
                offset: const Offset(0, 0),
                blurRadius: 10.0)
          ],
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 1.0],
            colors: [
              EaselAppTheme.kWhite02,
              EaselAppTheme.kPurple01,
            ],
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 14.0, right: 10, bottom: 4, top: 2),
          child: Image.asset(
            icon,
          ),
        ),
      ),
    );
  }
}

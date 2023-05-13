import 'package:flutter/material.dart';
import 'package:pylons_wallet/utils/constants.dart';

class ToggleButton extends StatefulWidget {
  final bool enabled;
  final void Function({required bool enabled}) onPressed;
  const ToggleButton({
    Key? key,
    required this.enabled,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ToggleClipper(),
      child: Container(
        height: 50,
        width: 100,
        color: widget.enabled ? AppColors.kGreenBackground.withOpacity(.7) : AppColors.kDarkRed.withOpacity(.7),
        padding: const EdgeInsets.all(6.0),
        child: widget.enabled ? enabledRow() : disableRow(),
      ),
    );
  }

  Widget enabledRow() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              widget.onPressed(enabled: false);
            },
            child: Container(
              alignment: Alignment.center,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.kButtonBuyNowColor,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              widget.onPressed(enabled: false);
            },
            child: ClipPath(
              clipper: ToggleClipper(),
              child: Container(
                color: Colors.white,
                height: double.infinity,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget disableRow() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              widget.onPressed(enabled: true);
            },
            child: ClipPath(
              clipper: ToggleClipper(),
              child: Container(
                color: Colors.white,
                height: double.infinity,
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              widget.onPressed(enabled: true);
            },
            child: SizedBox.expand(
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.kDarkRed),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ToggleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width - 10, size.height);
    path.lineTo(size.width, size.height - 10);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

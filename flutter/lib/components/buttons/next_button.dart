import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onTap;

  const NextButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const ImageIcon(
        AssetImage('assets/images/icon/more.png'),
        size: kIconSize,
        color: kSelectedIcon,
        key: ValueKey("NextButton"),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pylons_wallet/utils/constants.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onTap;

  const NextButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: ImageIcon(
        const AssetImage('assets/images/icons/more.png'),
        size: kIconSize,
        color: AppColors.kSelectedIcon,
        key: const ValueKey("NextButton"),
      ),
    );
  }
}

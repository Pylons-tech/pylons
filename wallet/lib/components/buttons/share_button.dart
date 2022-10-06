import 'package:flutter/material.dart';
import 'package:pylons_wallet/utils/constants.dart';

class ShareButton extends StatelessWidget {
  final VoidCallback onTap;

  const ShareButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        Icons.share_outlined,
        size: 20,
        color: AppColors.kSelectedIcon,
      ),
    );
  }
}

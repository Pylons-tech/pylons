import 'package:flutter/material.dart';
import 'package:pylons_wallet/utils/constants.dart';

class AddFriendButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const AddFriendButton({
    Key? key,
    required this.onTap,
    this.text = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: ImageIcon(
        const AssetImage('assets/images/icons/add_friend.png'),
        size: kIconSize,
        color: AppColors.kSelectedIcon,
        key: const ValueKey("Add-Friend-Button"),
      ),
    );
  }
}

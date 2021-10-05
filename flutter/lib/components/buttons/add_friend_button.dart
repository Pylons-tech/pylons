import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

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
       icon: const ImageIcon(
          AssetImage('assets/images/icon/add_friend.png'),
          size: kIconSize,
          color: kSelectedIcon,
         key: ValueKey("Add-Friend-Button"),
       ),
    );
  }
}

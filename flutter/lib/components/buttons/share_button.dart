import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

class ShareButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const ShareButton({
    Key? key,
    required this.onTap,
    this.text = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: this.onTap,
        icon: Icon(
          Icons.share_outlined,
          size: 20,
          color: kIconBGColor,
        ),
    );
  }
}

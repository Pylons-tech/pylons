import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

class MoreButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool showText;

  const MoreButton({
    Key? key,
    required this.onTap,
    this.showText = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          showText ? Text('More', style: TextStyle(fontWeight: FontWeight.w400),) : SizedBox.shrink(),
          ImageIcon(
            AssetImage('assets/images/icon/more.png'),
            size: kIconSize,
            color: kIconBGColor,
          ),
        ],
    )
    );
  }
}

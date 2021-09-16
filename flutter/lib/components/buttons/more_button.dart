import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

class MoreButton extends StatelessWidget {
  final VoidCallback onTap;

  const MoreButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: this.onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('more'),
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

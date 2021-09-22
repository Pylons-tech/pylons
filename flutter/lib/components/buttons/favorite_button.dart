import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';

class FavoriteButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const FavoriteButton({
    Key? key,
    required this.onTap,
    this.text = "",
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: this.onTap,
      icon: const Icon(
        Icons.favorite_outline,
        size: 20,
        color: kIconBGColor,
      ),
    );
  }
}
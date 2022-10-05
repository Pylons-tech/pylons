import 'package:flutter/material.dart';
import 'package:pylons_wallet/utils/constants.dart';

class FavoriteButton extends StatelessWidget {
  final VoidCallback onTap;

  const FavoriteButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        Icons.favorite_outline,
        size: 20,
        color: AppColors.kSelectedIcon,
      ),
    );
  }
}

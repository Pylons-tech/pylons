import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/material.dart';

class PylonsBlueButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const PylonsBlueButton({
    Key? key,
    required this.onTap,
    this.text = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        primary: const Color(0xFF1212C4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              text,
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

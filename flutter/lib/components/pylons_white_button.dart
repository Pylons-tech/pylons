import 'package:cosmos_ui_components/cosmos_app_theme.dart';
import 'package:flutter/material.dart';

class PylonsWhiteButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const PylonsWhiteButton({
    Key? key,
    required this.onTap,
    this.text = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xCCFFFFFF),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF1212C4))
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          primary: const Color(0xCCFFFFFF)
        ),
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(fontSize: 15, color:  Color(0xFF1212C4))),
            ],
          ),
        ),
      ),
    );
  }
}

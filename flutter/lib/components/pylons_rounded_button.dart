import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/space_widgets.dart';

class PylonsRoundedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final ImageProvider? glyph;

  const PylonsRoundedButton({
    Key? key,
    this.glyph,
    required this.onTap,
    this.text = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: Colors.grey)))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildChildren(),
        ),
      ),
    );
  }

  List<Widget> buildChildren() {
    final glyph = this.glyph;
    if (glyph != null) {
      return [
        Image(image: glyph),
        const HorizontalSpace(10),
        Expanded(
          child: Text(text, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400)),
        ),
      ];
    } else {
      return [
        Text(text, style: const TextStyle(color: Colors.black)),
      ];
    }
  }
}

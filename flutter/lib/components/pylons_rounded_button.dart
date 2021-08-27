import 'package:flutter/material.dart';

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
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.blue)
              )
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buildChildren(),
      ),
    );
  }

  List<Widget> buildChildren() {
      final glyph = this.glyph;
      if (glyph != null) {
        return [
          Image(image: glyph),
          Text(
              text,
              style: const TextStyle(color: Colors.black)),
        ];
      } else {
        return [
          Text(
              text,
              style: const TextStyle(color: Colors.black)),
        ];
      }
  }

}

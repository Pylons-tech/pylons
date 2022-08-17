import 'package:flutter/material.dart';
import 'package:pylons_wallet/utils/constants.dart';

class PylonsBlueButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool fulfilled;

  const PylonsBlueButton({
    Key? key,
    required this.onTap,
    this.text = "",
    this.fulfilled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        primary: fulfilled ? kBlue : kWhite,
        side: const BorderSide(width: 2.0, color: kBlue)
      ),
      child: SizedBox(
        // height: 43,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: fulfilled ? kWhite : kBlue)),
            ),
          ],
        ),
      ),
    );
  }
}

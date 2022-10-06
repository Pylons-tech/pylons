import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// Abstract Class for providing share feature
abstract class ShareHelper {
  /// This method will share text with other system apps
  /// Input: [text] the text you want to share, [size] the position of the widget that is clicked.
  void shareText({required String text, required Size size});
}

/// [ShareHelperImpl] implementation of [AudioPlayerHelper]
class ShareHelperImpl implements ShareHelper {

  @override
  void shareText({required String text, required Size size}) {
    Share.share(
      text,
      sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
    );
  }
}

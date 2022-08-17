
import 'package:flutter/material.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:share_plus/share_plus.dart';

/// Abstract Class for providing share feature
abstract class ShareHelper {

  /// This method provide the share feature of sharing files
  /// Input: [List][String] the files that you want to share
  void shareFiles({required List<String> filePath});


  /// This method will share text with other system apps
  /// Input: [text] the text you want to share, [size] the position of the widget that is clicked.
  void shareText({required String text, required Size size});


}

/// [ShareHelperImpl] implementation of [AudioPlayerHelper]
class ShareHelperImpl implements ShareHelper {
  @override
  void shareFiles({required List<String> filePath}) {
    final box = navigatorKey.currentState!.overlay!.context.findRenderObject() as RenderBox?;

    Share.shareFiles(
      filePath,
      text: '',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );


  }

  @override
  void shareText({required String text, required Size size}) {
    Share.share(
      text,
      sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
    );


  }
}

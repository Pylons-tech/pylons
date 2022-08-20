import 'package:flutter/cupertino.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';

const backgroundImage = BackgroundImage();

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return Image.asset(
      "assets/images/background.png",
      width: screenSize.width(percent: 0.5),
      height: screenSize.height(percent: 0.65),
    );
  }
}

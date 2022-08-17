import 'package:easel_flutter/utils/screen_size_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return SvgPicture.asset("assets/images/svg/background.svg",
      width: screenSize.width(percent: 50),
      height: screenSize.height(percent: 60),
      fit: BoxFit.fill,
    );
  }
}

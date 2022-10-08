import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Nft3dWidget extends StatelessWidget {
  final String url;
  final bool cameraControls;
  final Color backgroundColor;
  final bool showLoader;
  final Set<JavascriptChannel>? onProgress;
  final Function(String)? onError;

  const Nft3dWidget({Key? key, required this.backgroundColor, required this.url, required this.cameraControls, this.showLoader = false, this.onProgress, this.onError}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModelViewer(
          backgroundColor: backgroundColor,
          src: url,
          ar: false,
          autoRotate: false,
          cameraControls: cameraControls,
          relatedJs: "",
          onProgress: onProgress,
          onError: {
            JavascriptChannel(
                name: kErrorKey,
                onMessageReceived: (JavascriptMessage message) {
                  onError!(message.message);
                }),
          },
        ),
        if (showLoader)
          Center(
            child: SizedBox(
              height: 100.0.h,
              child: Image.asset(
                ImageUtil.LOADING_GIF,
                key: const Key(kImageAssetKey),
              ),
            ),
          )
        else
          const SizedBox()
      ],
    );
  }
}

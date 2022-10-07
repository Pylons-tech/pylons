import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Nft3dWidget extends StatefulWidget {
  final String url;
  final bool cameraControls;
  final Color backgroundColor;
  final bool showLoader;

  const Nft3dWidget({Key? key, required this.backgroundColor, required this.url, required this.cameraControls, this.showLoader = false}) : super(key: key);

  @override
  _Nft3dWidgetState createState() => _Nft3dWidgetState();
}

class _Nft3dWidgetState extends State<Nft3dWidget> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModelViewer(
          backgroundColor: widget.backgroundColor,
          src: widget.url,
          ar: false,
          autoRotate: false,
          cameraControls: widget.cameraControls,
          relatedJs: "",
          javascriptChannel: {
            JavascriptChannel(name: kLoadKey, onMessageReceived: (JavascriptMessage message) {}),
            JavascriptChannel(name: kErrorKey, onMessageReceived: (JavascriptMessage message) {}),
            JavascriptChannel(
                name: kProgressKey,
                onMessageReceived: (JavascriptMessage progress) {
                  if (double.parse(progress.message) == 1) {
                    setState(() {
                      loading = false;
                    });
                    return;
                  }
                }),
          },
        ),
        if (loading && widget.showLoader)
          Center(
            child: SizedBox(
              height: 100.0.h,
              child: Image.asset(
                ImageUtil.LOADING_GIF,
              ),
            ),
          )
        else
          const SizedBox()
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/provider/nft_3d_asset_provider.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/image_util.dart';

class Nft3dWidget extends StatelessWidget {
  final String url;
  final bool cameraControls;
  final Color backgroundColor;
  final bool showLoader;

  const Nft3dWidget({Key? key, required this.backgroundColor, required this.url, required this.cameraControls, this.showLoader = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Nft3DAssetProvider(),
      builder: (context, widget) {
        return Consumer<Nft3DAssetProvider>(builder: (context, viewModel, __) {
          return Nft3DWidgetContent(
            backgroundColor: backgroundColor,
            url: url,
            cameraControls: cameraControls,
            viewModel: viewModel,
            showLoader: showLoader,
          );
        });
      },
    );
  }
}

class Nft3DWidgetContent extends StatelessWidget {
  const Nft3DWidgetContent({
    Key? key,
    required this.backgroundColor,
    required this.url,
    required this.cameraControls,
    required this.viewModel,
    this.showLoader = false,
  }) : super(key: key);

  final Color backgroundColor;
  final String url;
  final bool cameraControls;
  final Nft3DAssetProvider viewModel;
  final bool showLoader;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: Stack(
        children: [
          ModelViewer(
            backgroundColor: backgroundColor,
            src: url,
            ar: false,
            autoRotate: false,
            cameraControls: cameraControls,
            relatedJs: "",
            onProgress: (status) {
              if (status == 1) {
                Future.delayed(const Duration(seconds: 1), () {
                  viewModel.toggleLoader();
                });
              }
            },
            onError: (error) {
              error.show();
            },
          ),
          if (viewModel.showLoader.value && showLoader)
            Container(
              color: Colors.black,
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: SizedBox(
                  height: 100.0.h,
                  child: Image.asset(
                    ImageUtil.LOADING_GIF,
                    key: const Key(kImageAssetKey),
                  ),
                ),
              ),
            )
          else
            const SizedBox()
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pylons_wallet/utils/enums.dart';

class PreviewNFTGrid extends StatelessWidget {
  final WidgetBuilder onVideoNFT;
  final WidgetBuilder onAudioNFT;
  final WidgetBuilder on3dNFT;
  final WidgetBuilder onImageNFT;
  final WidgetBuilder onPdfNFT;

  final AssetType assetType;

  const PreviewNFTGrid({Key? key, required this.on3dNFT, required this.onAudioNFT, required this.onVideoNFT,required this.onPdfNFT, required this.onImageNFT, required this.assetType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (assetType) {
      case AssetType.Audio:
        return onAudioNFT(context);
      case AssetType.Image:
        return onImageNFT(context);
      case AssetType.Video:
        return onVideoNFT(context);
      case AssetType.ThreeD:
        return on3dNFT(context);
      case AssetType.Pdf:
        return onPdfNFT(context);
    }
  }
}

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/utils/image_util.dart';



import '../../components/pylons_app_theme.dart';
import '../../utils/constants.dart';
import '../detailed_asset_view/widgets/nft_3d_asset.dart';
import '../detailed_asset_view/widgets/pdf_placeholder.dart';
import '../detailed_asset_view/widgets/video_placeholder.dart';
import '../home/collection_screen/collection_view_model.dart';
import '../home/collection_screen/collection_screen.dart';

import '../home/collection_screen/preview_nft_grid.dart';



class WidgetNFTPickerScreen extends StatefulWidget {
  const WidgetNFTPickerScreen({Key? key}) : super(key: key);

  @override
  State<WidgetNFTPickerScreen> createState() => _WidgetNFTPickerScreenState();
}

class _WidgetNFTPickerScreenState extends State<WidgetNFTPickerScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      context.read<CollectionViewModel>().init();
    });
  }

  Widget getAudioThumbnailFromUrl({required String thumbnailUrl}) {
    return Stack(
      children: [
        Positioned.fill(
            child: CachedNetworkImage(
                placeholder: (context, url) => Shimmer(
                  color: PylonsAppTheme.cardBackground,
                  child: const SizedBox.expand(),
                ),
                imageUrl: thumbnailUrl,
                fit: BoxFit.cover)),
        Align(
          child: Container(
            width: 35.w,
            height: 35.h,
            decoration: BoxDecoration(color: kWhite.withOpacity(0.5), shape: BoxShape.circle),
            child: Image.asset(
              ImageUtil.AUDIO_ICON,
              width: 35.w,
              height: 35.h,
              color: kBlack.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }

  Widget getAudioPlaceHolder({required String thumbnailUrl}) {
    return thumbnailUrl.isEmpty ? Image.asset(ImageUtil.AUDIO_BACKGROUND, fit: BoxFit.cover) : getAudioThumbnailFromUrl(thumbnailUrl: thumbnailUrl);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CollectionViewModel>();
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StaggeredGridView.countBuilder(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    crossAxisSpacing: 8,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    itemCount: viewModel.purchases.length,
                    itemBuilder: (context, index) {
                      final nft = viewModel.purchases[index];
                      return GestureDetector(
                        onTap: () {
                          //onNFTSelected(nft);
                        },
                        child: ClipRRect(
                          child: PreviewNFTGrid(
                            assetType: nft.assetType,
                            on3dNFT: (BuildContext context) => Container(
                              color: k3DBackgroundColor,
                              height: double.infinity,
                              child: IgnorePointer(
                                child: Nft3dWidget(
                                  url: nft.url,
                                  cameraControls: false,
                                  backgroundColor: k3DBackgroundColor,
                                ),
                              ),
                            ),
                            onPdfNFT: (BuildContext context) => PdfPlaceHolder(nftUrl: nft.url, nftName: nft.name, thumbnailUrl: nft.thumbnailUrl),
                            onVideoNFT: (BuildContext context) => VideoPlaceHolder(nftUrl: nft.url, nftName: nft.name, thumbnailUrl: nft.thumbnailUrl),
                            onImageNFT: (BuildContext context) => CachedNetworkImage(
                                placeholder: (context, url) => Shimmer(color: PylonsAppTheme.cardBackground, child: const SizedBox.expand()), imageUrl: nft.url, fit: BoxFit.cover),
                            onAudioNFT: (BuildContext context) => getAudioPlaceHolder(thumbnailUrl: nft.thumbnailUrl),
                          ),
                        ),
                      );
                    },
                    staggeredTileBuilder: (index) {
                      return PylonsAppTheme.getStaggeredTile(index);
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
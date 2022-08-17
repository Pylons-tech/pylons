import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/published_nfts_bottom_sheet.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class NFTsListTile extends StatelessWidget {
  final NFT publishedNFT;

  const NFTsListTile({Key? key, required this.publishedNFT}) : super(key: key);

  EaselProvider get _easelProvider => GetIt.I.get();

  void buildBottomSheet({required BuildContext context}) {
    final bottomSheet = BuildPublishedNFTsBottomSheet(context: context, nft: publishedNFT, easelProvider: _easelProvider);

    bottomSheet.show();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 3.w),
        decoration: BoxDecoration(color: EaselAppTheme.kWhite, boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0.0, 1.0),
            blurRadius: 4.0,
          ),
        ]),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Row(
            children: [
              SizedBox(
                  height: 45.h,
                  width: 45.h,
                  child: NftTypeBuilder(
                    onImage: (context) => CachedNetworkImage(
                      errorWidget: (context, url, error) => Align(
                        child: SvgPicture.asset(
                          kSvgNftFormatImage,
                          color: EaselAppTheme.kBlack,
                        ),
                      ),
                      placeholder: (context, url) => Shimmer(color: EaselAppTheme.cardBackground, child: const SizedBox.expand()),
                      imageUrl: publishedNFT.url.changeDomain(),
                      fit: BoxFit.cover,
                    ),
                    onVideo: (context) => CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: publishedNFT.thumbnailUrl.changeDomain(),
                      errorWidget: (a, b, c) => const Center(child: Icon(Icons.error_outline)),
                      placeholder: (context, url) => Shimmer(color: EaselAppTheme.cardBackground, child: const SizedBox.expand()),
                    ),
                    onPdf: (context) => CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: publishedNFT.thumbnailUrl,
                      errorWidget: (a, b, c) => const Center(child: Icon(Icons.error_outline)),
                      placeholder: (context, url) => Shimmer(color: EaselAppTheme.cardBackground, child: const SizedBox.expand()),
                    ),
                    onAudio: (context) => CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: publishedNFT.thumbnailUrl.changeDomain(),
                      errorWidget: (a, b, c) => const Center(child: Icon(Icons.error_outline)),
                      placeholder: (context, url) => Shimmer(color: EaselAppTheme.cardBackground, child: const SizedBox.expand()),
                    ),
                    on3D: (context) => ModelViewer(
                      src: publishedNFT.url.changeDomain(),
                      backgroundColor: EaselAppTheme.kWhite,
                      ar: false,
                      autoRotate: false,
                      cameraControls: false,
                    ),
                    assetType: publishedNFT.assetType.toAssetTypeEnum(),
                  )),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      publishedNFT.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: EaselAppTheme.titleStyle.copyWith(fontSize: isTablet ? 13.sp : 18.sp),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.h),
                            color: EaselAppTheme.kDarkGreen,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                          child: Text(
                            "publish".tr(),
                            style: EaselAppTheme.titleStyle.copyWith(color: EaselAppTheme.kWhite, fontSize: isTablet ? 8.sp : 11.sp),
                          ),
                        ),
                        SizedBox(width: 9.w),
                        if (publishedNFT.isEnabled && publishedNFT.amountMinted < int.parse(publishedNFT.quantity))
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                            child: Text(
                              "for_sale".tr(),
                              style: EaselAppTheme.titleStyle.copyWith(color: EaselAppTheme.kWhite, fontSize: isTablet ? 8.sp : 11.sp),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.h),
                              color: EaselAppTheme.kBlue,
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              InkWell(
                  onTap: () => buildBottomSheet(context: context),
                  child: Padding(
                    padding: EdgeInsets.all(4.0.w),
                    child: SvgPicture.asset(kSvgMoreOption),
                  ))
            ],
          ),
        ));
  }
}

class NftTypeBuilder extends StatelessWidget {
  final WidgetBuilder onImage;
  final WidgetBuilder onVideo;
  final WidgetBuilder onAudio;
  final WidgetBuilder on3D;
  final WidgetBuilder onPdf;
  final AssetType assetType;

  const NftTypeBuilder({
    Key? key,
    required this.onImage,
    required this.onVideo,
    required this.onAudio,
    required this.on3D,
    required this.onPdf,
    required this.assetType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (assetType) {
      case AssetType.Audio:
        return onAudio(context);
      case AssetType.Image:
        return onImage(context);
      case AssetType.Video:
        return onVideo(context);
      case AssetType.Pdf:
        return onPdf(context);
      case AssetType.ThreeD:
        return on3D(context);
    }
  }
}

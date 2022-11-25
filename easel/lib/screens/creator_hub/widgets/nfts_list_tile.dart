import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/published_nfts_bottom_sheet.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../generated/locale_keys.g.dart';

class NFTsListTile extends StatelessWidget {
  final NFT publishedNFT;
  final CreatorHubViewModel viewModel;

  const NFTsListTile({Key? key, required this.publishedNFT, required this.viewModel}) : super(key: key);

  EaselProvider get _easelProvider => GetIt.I.get();

  void buildBottomSheet({required BuildContext context}) {
    final bottomSheet = BuildPublishedNFTsBottomSheet(context: context, nft: publishedNFT, easelProvider: _easelProvider);

    bottomSheet.show();
  }

  Future<void> onViewOnPylonsPressed() async {
    final String url = publishedNFT.recipeID.generateEaselLinkForOpeningInPylonsApp(cookbookId: publishedNFT.cookbookID);
    await _easelProvider.repository.launchMyUrl(url: url);
  }

  Widget getPublishedCard({required BuildContext context}) {
    return InkWell(
      key: const Key(kNftTileKey),
      onTap: () {
        Navigator.of(context).pushNamed(
          RouteUtil.kOwnerViewScreen,
          arguments: publishedNFT,
        );
        // viewModel.onViewOnPylons(onViewOnPylonsPressed: onViewOnPylonsPressed);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: EaselAppTheme.kWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0.0, 1.0),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          child: Row(
            children: [
              SizedBox(
                height: 45.h,
                width: 45.w,
                child: NftTypeBuilder(
                  onImage: (context) => buildCachedNetworkImage(publishedNFT.url.changeDomain()),
                  onVideo: (context) => buildCachedNetworkImage(publishedNFT.thumbnailUrl.changeDomain()),
                  onPdf: (context) => buildCachedNetworkImage(publishedNFT.thumbnailUrl.changeDomain()),
                  onAudio: (context) => buildCachedNetworkImage(publishedNFT.thumbnailUrl.changeDomain()),
                  on3D: (context) => ModelViewer(
                    src: publishedNFT.url.changeDomain(),
                    backgroundColor: EaselAppTheme.kWhite,
                    ar: false,
                    autoRotate: false,
                    cameraControls: false,
                  ),
                  assetType: publishedNFT.assetType.toAssetTypeEnum(),
                ),
              ),
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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.h),
                        color: EaselAppTheme.kDarkGreen,
                      ),
                      child: Text(
                        LocaleKeys.published.tr(),
                        style: EaselAppTheme.titleStyle.copyWith(color: EaselAppTheme.kWhite, fontSize: isTablet ? 8.sp : 11.sp),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              InkWell(
                key: const Key(kNFTMoreOptionButtonKey),
                onTap: () => buildBottomSheet(context: context),
                child: Padding(
                  padding: EdgeInsets.all(4.0.w),
                  child: SvgPicture.asset(SVGUtils.kSvgMoreOption),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (publishedNFT.price.isNotEmpty && double.parse(publishedNFT.price) > 0)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Card(
              elevation: 5,
              margin: EdgeInsets.zero,
              child: ClipRRect(
                child: Banner(
                  key: Key("${publishedNFT.ibcCoins.getCoinWithProperDenomination(publishedNFT.price)} ${publishedNFT.ibcCoins.getAbbrev()}"),
                  color: EaselAppTheme.kDarkGreen,
                  location: BannerLocation.topEnd,
                  message: "${publishedNFT.ibcCoins.getCoinWithProperDenomination(publishedNFT.price)} ${publishedNFT.ibcCoins.getAbbrev()}",
                  child: getPublishedCard(context: context),
                ),
              ),
            ),
          )
        else
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: getPublishedCard(context: context),
          ),
        if (publishedNFT.assetType.toAssetTypeEnum() != AssetType.ThreeD)
          IgnorePointer(
            child: SizedBox(
              height: 85.0.h,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: publishedNFT.assetType.toAssetTypeEnum() == AssetType.Image ? publishedNFT.url.changeDomain() : publishedNFT.thumbnailUrl.changeDomain(),
                fit: BoxFit.fill,
                color: Colors.transparent,
                colorBlendMode: BlendMode.clear,
                placeholder: (context, url) => Shimmer(
                  color: EaselAppTheme.cardBackground,
                  child: const SizedBox.expand(),
                ),
                errorWidget: (context, _, __) {
                  return const IgnorePointer(child: SizedBox());
                },
              ),
            ),
          )
        else
          IgnorePointer(
            child: SizedBox(
              height: 85.h,
            ),
          ),
      ],
    );
  }

  CachedNetworkImage buildCachedNetworkImage(String url) {
    return CachedNetworkImage(
      fit: BoxFit.fill,
      imageUrl: url,
      errorWidget: (a, b, c) => const Center(child: Icon(Icons.error_outline)),
      placeholder: (context, url) => Shimmer(color: EaselAppTheme.cardBackground, child: const SizedBox.expand()),
    );
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

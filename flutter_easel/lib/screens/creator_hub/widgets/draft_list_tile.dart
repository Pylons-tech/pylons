import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/drafts_more_bottomsheet.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/nfts_list_tile.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class DraftListTile extends StatelessWidget {
  final NFT nft;
  final CreatorHubViewModel viewModel;
  const DraftListTile({Key? key, required this.nft, required this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(nft.id),
      closeOnScroll: false,
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                viewModel.deleteNft(nft.id);
              },
              child: SvgPicture.asset(kSvgDelete),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                viewModel.saveNFT(nft: nft);
                Navigator.of(context).pushNamed(RouteUtil.kRouteHome);
              },
              child: SvgPicture.asset(kSvgPublish),
            ),
          )
        ],
      ),
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 3.w),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
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
                        placeholder: (context, url) => Shimmer(
                            color: EaselAppTheme.cardBackground,
                            child: const SizedBox.expand()),
                        imageUrl: nft.url.changeDomain(),
                        fit: BoxFit.cover,
                      ),
                      onVideo: (context) => CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: nft.thumbnailUrl.changeDomain(),
                        errorWidget: (a, b, c) =>
                            const Center(child: Icon(Icons.error_outline)),
                        placeholder: (context, url) => Shimmer(
                            color: EaselAppTheme.cardBackground,
                            child: const SizedBox.expand()),
                      ),
                      onPdf: (context) => CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: nft.thumbnailUrl,
                        errorWidget: (a, b, c) =>
                            const Center(child: Icon(Icons.error_outline)),
                        placeholder: (context, url) => Shimmer(
                            color: EaselAppTheme.cardBackground,
                            child: const SizedBox.expand()),
                      ),
                      onAudio: (context) => CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: nft.thumbnailUrl.changeDomain(),
                        errorWidget: (a, b, c) =>
                            const Center(child: Icon(Icons.error_outline)),
                        placeholder: (context, url) => Shimmer(
                            color: EaselAppTheme.cardBackground,
                            child: const SizedBox.expand()),
                      ),
                      on3D: (context) => ModelViewer(
                        src: nft.url.changeDomain(),
                        backgroundColor: EaselAppTheme.kWhite,
                        ar: false,
                        autoRotate: false,
                        cameraControls: false,
                      ),
                      assetType: nft.assetType.toAssetTypeEnum(),
                    )),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "nft_name".tr(args: [
                          nft.name.isNotEmpty ? nft.name : 'Nft Name'
                        ]),
                        style: titleStyle.copyWith(
                            fontSize: isTablet ? 13.sp : 18.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.h),
                          color: EaselAppTheme.kLightRed,
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 3.h),
                        child: Text(
                          "draft".tr(),
                          style: EaselAppTheme.titleStyle.copyWith(
                              color: EaselAppTheme.kWhite,
                              fontSize: isTablet ? 8.sp : 11.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                InkWell(
                    onTap: () {
                      final DraftsBottomSheet draftsBottomSheet =
                          DraftsBottomSheet(
                        buildContext: context,
                        nft: nft,
                      );
                      draftsBottomSheet.show();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(4.0.w),
                      child: SvgPicture.asset(kSvgMoreOption),
                    ))
              ],
            ),
          )),
    );
  }
}

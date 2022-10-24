import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/drafts_more_bottomsheet.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/nfts_list_tile.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/published_nfts_bottom_sheet.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../main.dart';

class NftGridViewItem extends StatelessWidget {
  const NftGridViewItem({Key? key, required this.nft,required this.collectionType}) : super(key: key);
  final NFT nft;
  final CollectionType collectionType;

  EaselProvider get _easelProvider => GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            height: 200.h,
            width: 150.w,
            child: InkWell(
              key: const Key(kGridViewTileNFTKey),
              onTap: () {
                if (context.read<CreatorHubViewModel>().selectedCollectionType == CollectionType.draft) {
                  final DraftsBottomSheet draftsBottomSheet = DraftsBottomSheet(
                    buildContext: context,
                    nft: nft,
                  );
                  draftsBottomSheet.show();
                  return;
                }
                buildBottomSheet(context: context);
              },
              child: NftTypeBuilder(
                onImage: (context) => buildNFTPreview(url: nft.url.changeDomain()),
                onVideo: (context) => buildNFTPreview(url: nft.thumbnailUrl.changeDomain()),
                onAudio: (context) => buildNFTPreview(url: nft.thumbnailUrl.changeDomain()),
                onPdf: (context) => buildNFTPreview(url: nft.thumbnailUrl.changeDomain()),
                on3D: (context) => IgnorePointer(
                  child: ModelViewer(
                    src: nft.url.changeDomain(),
                    ar: false,
                    autoRotate: false,
                    backgroundColor: EaselAppTheme.kWhite,
                    cameraControls: false,
                  ),
                ),
                assetType: nft.assetType.toAssetTypeEnum(),
              ),
            )),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.black87,Colors.black54,Colors.black45,Colors.black38,
              Colors.black26,Colors.black12,Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.h),
                  color: collectionType == CollectionType.draft ?EaselAppTheme.kLightRed:
                  nft.isEnabled && nft.amountMinted < int.parse(nft.quantity)?EaselAppTheme.kBlue:EaselAppTheme.kDarkGreen,
                ),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                child: Text(
                  collectionType == CollectionType.draft ?"draft".tr():
                  nft.isEnabled && nft.amountMinted < int.parse(nft.quantity)?"for_sale".tr():"publish".tr(),
                  style: EaselAppTheme.titleStyle.copyWith(color: EaselAppTheme.kWhite, fontSize: isTablet ? 8.sp : 11.sp),
                ),
              ),
              const Spacer(),
              InkWell(
                  onTap: () {
                    final DraftsBottomSheet draftsBottomSheet = DraftsBottomSheet(
                      buildContext: context,
                      nft: nft,
                    );
                    draftsBottomSheet.show();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(4.0.w),
                    child: SvgPicture.asset(SVGUtils.kSvgMoreOption,color: Colors.white),
                  )),
              const SizedBox(width: 5,)
            ],
          ),
        )
      ],
    );
  }

  CachedNetworkImage buildNFTPreview({required String url}) {
    return CachedNetworkImage(
      fit: BoxFit.fitHeight,
      imageUrl: url,
      errorWidget: (a, b, c) => const Center(child: Icon(Icons.error_outline)),
      placeholder: (context, url) => Shimmer(color: EaselAppTheme.cardBackground, child: const SizedBox.expand()),
    );
  }

  void buildBottomSheet({required BuildContext context}) {
    final bottomSheet = BuildPublishedNFTsBottomSheet(context: context, nft: nft, easelProvider: _easelProvider);

    bottomSheet.show();
  }
}

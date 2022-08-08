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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class NftGridViewItem extends StatelessWidget {
  const NftGridViewItem({Key? key, required this.nft}) : super(key: key);
  final NFT nft;

  EaselProvider get _easelProvider => GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            height: 200.h,
            width: 150.w,
            child: NftTypeBuilder(
              onImage: (context) => CachedNetworkImage(
                errorWidget: (a, b, c) =>
                    const Center(child: Icon(Icons.error_outline)),
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
              onAudio: (context) => CachedNetworkImage(
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
              on3D: (context) => ModelViewer(
                src: nft.url.changeDomain(),
                ar: false,
                autoRotate: false,
                backgroundColor: EaselAppTheme.kWhite,
                cameraControls: false,
              ),
              assetType: nft.assetType.toAssetTypeEnum(),
            )),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
              onTap: () {
                if (context
                        .read<CreatorHubViewModel>()
                        .selectedCollectionType ==
                    CollectionType.draft) {
                  final DraftsBottomSheet draftsBottomSheet = DraftsBottomSheet(
                    buildContext: context,
                    nft: nft,
                  );
                  draftsBottomSheet.show();
                  return;
                }
                buildBottomSheet(context: context);
              },
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: SvgPicture.asset(
                  kSvgMoreOption,
                  color: EaselAppTheme.kWhite,
                ),
              )),
        )
      ],
    );
  }

  void buildBottomSheet({required BuildContext context}) {
    final bottomSheet = BuildPublishedNFTsBottomSheet(
        context: context, nft: nft, easelProvider: _easelProvider);

    bottomSheet.show();
  }
}

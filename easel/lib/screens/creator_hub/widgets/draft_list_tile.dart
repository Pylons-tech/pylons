import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/delete_confirmation_dialog.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/drafts_more_bottomsheet.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/nfts_list_tile.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class DraftListTile extends StatefulWidget {
  final NFT nft;
  final CreatorHubViewModel viewModel;
  const DraftListTile({Key? key, required this.nft, required this.viewModel}) : super(key: key);

  @override
  State<DraftListTile> createState() => _DraftListTileState();
}

class _DraftListTileState extends State<DraftListTile> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(widget.nft.id),
      closeOnScroll: false,
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const ScrollMotion(),
        children: [
          buildSlidableAction(
            context,
            callback: () {
              final DeleteDialog deleteDialog = DeleteDialog(contextt: context, nft: widget.nft);
              deleteDialog.show();
            },
            icon: kSvgDelete,
          ),
          buildSlidableAction(
            context,
            callback: () {
              onViewOnIPFSPressed(nft: widget.nft, context: context);
            },
            icon: kSvgIpfsLogo,
            isSvg: false,
          ),
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
                buildAssetView(),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "nft_name".tr(args: [widget.nft.name.isNotEmpty ? widget.nft.name : 'Nft Name']),
                        style: titleStyle.copyWith(fontSize: isTablet ? 13.sp : 18.sp),
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
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                        child: Text(
                          "draft".tr(),
                          style: EaselAppTheme.titleStyle.copyWith(color: EaselAppTheme.kWhite, fontSize: isTablet ? 8.sp : 11.sp),
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
                      final DraftsBottomSheet draftsBottomSheet = DraftsBottomSheet(
                        buildContext: context,
                        nft: widget.nft,
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

  Widget buildSlidableAction(BuildContext context, {required VoidCallback callback, required String icon, bool isSvg = true}) {
    return Expanded(
      child: InkWell(
        onTap: callback,
        child: isSvg ? SvgPicture.asset(icon) : Image.asset(icon),
      ),
    );
  }

  SizedBox buildAssetView() {
    return SizedBox(
        height: 45.h,
        width: 45.h,
        child: NftTypeBuilder(
          onImage: (context) => buildCachedNetworkImage(widget.nft.url.changeDomain()),
          onVideo: (context) => buildCachedNetworkImage(widget.nft.thumbnailUrl.changeDomain()),
          onPdf: (context) => buildCachedNetworkImage(widget.nft.thumbnailUrl.changeDomain()),
          onAudio: (context) => buildCachedNetworkImage(widget.nft.thumbnailUrl.changeDomain()),
          on3D: (context) => ModelViewer(
            src: widget.nft.url.changeDomain(),
            backgroundColor: EaselAppTheme.kWhite,
            ar: false,
            autoRotate: false,
            cameraControls: false,
          ),
          assetType: widget.nft.assetType.toAssetTypeEnum(),
        ));
  }

  CachedNetworkImage buildCachedNetworkImage(String url) {
    return CachedNetworkImage(
      fit: BoxFit.fill,
      imageUrl: url,
      errorWidget: (a, b, c) => const Center(child: Icon(Icons.error_outline)),
      placeholder: (context, url) => Shimmer(color: EaselAppTheme.cardBackground, child: const SizedBox.expand()),
    );
  }

  void onViewOnIPFSPressed({required BuildContext context, required NFT nft}) async {
    switch (nft.assetType) {
      case k3dText:
      case kPdfText:
        await Clipboard.setData(ClipboardData(text: nft.cid));
        if (mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("copied_to_clipboard".tr())));
        }
        break;
      default:
        final easelProvider = Provider.of<EaselProvider>(context, listen: false);
        await easelProvider.repository.launchMyUrl(url: nft.url.changeDomain());
    }
  }
}

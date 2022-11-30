import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/screens/creator_hub/widgets/delete_confirmation_dialog.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/dependency_injection/dependency_injection_container.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/widgets/cid_or_ipfs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../widgets/clippers/bottom_sheet_clipper.dart';

TextStyle titleStyle = TextStyle(fontSize: isTablet ? 13.sp : 16.sp, fontWeight: FontWeight.w800, fontFamily: kUniversalFontFamily, color: EaselAppTheme.kBlack);

class DraftsBottomSheet {
  final BuildContext buildContext;
  final NFT nft;

  CreatorHubViewModel get creatorHubViewModel => sl();

  DraftsBottomSheet({required this.buildContext, required this.nft});

  Future<void> show() async {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: buildContext,
      builder: (_) {
        return ChangeNotifierProvider.value(
          value: creatorHubViewModel,
          child: DraftsMoreBottomSheet(
            key: const Key(kNFTMoreOptionBottomSheetKey),
            nft: nft,
          ),
        );
      },
    );
  }
}

class DraftsMoreBottomSheet extends StatelessWidget {
  const DraftsMoreBottomSheet({Key? key, required this.nft}) : super(key: key);

  final NFT nft;

  EaselProvider get easelProvider => sl();

  Future<void> onViewOnIPFSPressed({required BuildContext context, required NFT nft}) async {
    final easelProvider = Provider.of<EaselProvider>(context, listen: false);
    await easelProvider.repository.launchMyUrl(url: nft.url.changeDomain());
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BottomSheetClipper(),
      child: Container(
        color: EaselAppTheme.kLightGrey02,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
        child: Wrap(
          children: [
            moreOptionTile(
                title: "delete".tr(),
                image: SVGUtils.kSvgDelete,
                onPressed: () {
                  Navigator.of(context).pop();
                  final DeleteDialog deleteDialog = DeleteDialog(contextt: context, nft: nft);

                  deleteDialog.show();
                }),
            const Divider(
              color: EaselAppTheme.kGrey,
            ),
            CidOrIpfs(
                viewCid: (context) {
                  return moreOptionTile(
                    onPressed: () async {
                      final state = ScaffoldMessenger.of(context);
                      Navigator.of(context).pop();
                      await Clipboard.setData(ClipboardData(text: nft.cid));
                      state
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(content: Text(LocaleKeys.copied_to_clipboard.tr())),
                        );
                    },
                    title: LocaleKeys.copy_cid.tr(),
                    image: PngUtils.kSvgIpfsLogo,
                    isSvg: false,
                  );
                },
                viewIpfs: (context) {
                  return moreOptionTile(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      onViewOnIPFSPressed(nft: nft, context: context);
                    },
                    title: LocaleKeys.view.tr(),
                    image: PngUtils.kSvgIpfsLogo,
                    isSvg: false,
                  );
                },
                type: nft.assetType)
          ],
        ),
      ),
    );
  }

  void navigateToPreviewScreen({required BuildContext context, required NFT nft}) {
    easelProvider.setPublishedNFTClicked(nft);
    easelProvider.setPublishedNFTDuration(nft.duration);
    Navigator.of(context).pushReplacementNamed(RouteUtil.kRoutePreviewNFTFullScreen);
  }
}

Widget moreOptionTile({required String title, required String image, required VoidCallback onPressed, bool isSvg = true}) {
  final TextStyle titleStyle = TextStyle(fontSize: isTablet ? 13.sp : 16.sp, fontWeight: FontWeight.w800, fontFamily: kUniversalFontFamily, color: EaselAppTheme.kBlack);

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.h),
    child: InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          if (isSvg)
            SvgPicture.asset(
              image,
              height: isTablet ? 20.h : 16.h,
              fit: BoxFit.fitHeight,
            )
          else
            Image.asset(
              image,
              height: isTablet ? 20.h : 16.h,
              fit: BoxFit.fitHeight,
            ),
          SizedBox(
            width: 30.w,
          ),
          Text(
            title,
            style: titleStyle.copyWith(fontSize: 16.sp),
          )
        ],
      ),
    ),
  );
}

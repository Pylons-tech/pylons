import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/widgets/cid_or_ipfs.dart';
import 'package:easel_flutter/widgets/clippers/bottom_sheet_clipper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BuildPublishedNFTsBottomSheet {
  final BuildContext context;
  final NFT nft;
  final EaselProvider easelProvider;

  BuildPublishedNFTsBottomSheet({required this.context, required this.nft, required this.easelProvider});

  Widget moreOptionTile({required String title, required String image, required VoidCallback onPressed, final bool isSvg = true}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: InkWell(
        onTap: () => onPressed(),
        child: Row(
          children: [
            isSvg ? SvgPicture.asset(image) : Image.asset(image),
            SizedBox(width: 30.w),
            Text(
              title.tr(),
              style: EaselAppTheme.titleStyle.copyWith(
                fontSize: isTablet ? 13.sp : 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onViewOnIPFSPressed({required NFT nft}) async {
    await easelProvider.repository.launchMyUrl(url: nft.url.changeDomain());
  }

  void onViewOnPylonsPressed({required NFT nft}) async {
    String url = nft.recipeID.generateEaselLinkForOpeningInPylonsApp(cookbookId: nft.cookbookID);

    await easelProvider.repository.launchMyUrl(url: url);
  }

  Future show() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return ClipPath(
            clipper: BottomSheetClipper(),
            child: Container(
              color: EaselAppTheme.kBgColor,
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
              child: Wrap(
                children: [
                  moreOptionTile(
                      onPressed: () {
                        onViewOnPylonsPressed(nft: nft);
                      },
                      title: "view_on_pylons".tr(),
                      image: kSvgPylonsLogo),
                  Divider(thickness: 1.h),
                  CidOrIpfs(
                    viewCid: (context) {
                      return moreOptionTile(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await Clipboard.setData(ClipboardData(text: nft.cid));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("copied_to_clipboard".tr())),
                          );
                        },
                        title: "copy_cid".tr(),
                        image: kSvgIpfsLogo,
                        isSvg: false,
                      );
                    },
                    viewIpfs: (context) {
                      return moreOptionTile(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            onViewOnIPFSPressed(nft: nft);
                          },
                          title: "view".tr(),
                          image: kSvgIpfsLogo,
                          isSvg: false);
                    },
                    type: nft.assetType,
                  )
                ],
              ),
            ),
          );
        });
  }
}

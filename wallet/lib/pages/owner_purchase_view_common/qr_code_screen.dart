import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/nft_3d_asset.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/nft_image_asset.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/extension.dart';
import 'package:pylons_wallet/utils/svg_util.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({Key? key, required this.nft}) : super(key: key);

  final NFT nft;

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  String link = "";
  GlobalKey renderObjectKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    createLink();
  }

  void createLink() {
    final address =
        GetIt.I.get<WalletsStore>().getWallets().value.last.publicAddress;

    switch (widget.nft.type) {
      case NftType.TYPE_TRADE:
        link = widget.nft.tradeID.createTradeLink(address: address);
        break;

      case NftType.TYPE_ITEM:
        link = widget.nft.recipeID.createDynamicLink(
            cookbookId: widget.nft.cookbookID, address: address);
        break;

      case NftType.TYPE_RECIPE:
        link = widget.nft.recipeID.createDynamicLink(
            cookbookId: widget.nft.cookbookID, address: address);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.kBlack,
      child: Stack(
        children: [
          getTypeWidget(widget.nft),
          Padding(
            padding: EdgeInsets.only(
                left: 23.w, top: MediaQuery.of(context).viewPadding.top + 13.h),
            child: GestureDetector(
              onTap: () async {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                SVGUtil.OWNER_BACK_ICON,
                height: 25.h,
              ),
            ),
          ),
          ColoredBox(
            color: AppColors.kBlack.withOpacity(0.5),
            child: Align(
              child: RepaintBoundary(
                key: renderObjectKey,
                child: QrImage(
                  padding: EdgeInsets.zero,
                  data: link,
                  size: 200,
                  foregroundColor: AppColors.kWhite,
                ),
              ),
            ),
          ),
          Align(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SvgPicture.asset(SVGUtil.QR_SIDE_BORDER),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: CustomPaintButton(
                  title: "done".tr(),
                  bgColor: AppColors.kWhite.withOpacity(0.3),
                  width: 280.w,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
          )
        ],
      ),
    );
  }

  Widget getTypeWidget(NFT nft) {
    switch (nft.assetType) {
      case AssetType.Audio:
        return NftImageWidget(
          url: nft.thumbnailUrl,
          opacity: 0.5,
        );
      case AssetType.Image:
        return NftImageWidget(
          url: nft.url,
          opacity: 0.5,
        );
      case AssetType.Video:
        return NftImageWidget(
          url: nft.thumbnailUrl,
          opacity: 0.5,
        );
      case AssetType.Pdf:
        return NftImageWidget(
          url: nft.thumbnailUrl,
          opacity: 0.5,
        );
      case AssetType.ThreeD:
        return Nft3dWidget(
          url: nft.url,
          cameraControls: false,
          backgroundColor: AppColors.kBlack.withOpacity(0.5),
        );
    }
  }
}

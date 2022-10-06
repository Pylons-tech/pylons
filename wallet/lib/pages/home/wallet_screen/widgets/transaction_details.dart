import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
import 'package:pylons_wallet/model/transaction.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/nft_3d_asset.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/pdf_placeholder.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/video_placeholder.dart';
import 'package:pylons_wallet/pages/home/collection_screen/preview_nft_grid.dart';
import 'package:pylons_wallet/pages/home/home_provider.dart';
import 'package:pylons_wallet/pages/home/wallet_screen/widgets/latest_transactions.dart';
import 'package:pylons_wallet/pages/home/wallet_screen/widgets/view_in_collection_button.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/extension.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

TextStyle _titleTextStyle = TextStyle(color: AppColors.kBlack, fontFamily: kUniversalFontFamily, fontWeight: FontWeight.bold, fontSize: 20.sp);

class TransactionDetailsScreen extends StatefulWidget {
  const TransactionDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionDetailsScreen> createState() => _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  Repository get repository => GetIt.I.get();

  @override
  void initState() {
    super.initState();
    repository.logUserJourney(screenName: AnalyticsScreenEvents.transactionDetails);
  }

  bool getTxTypeFlag({required WalletHistoryTransactionType txType}) {
    switch (txType) {
      case WalletHistoryTransactionType.SEND:
        return false;
      case WalletHistoryTransactionType.RECEIVE:
        return true;
      case WalletHistoryTransactionType.NFTBUY:
        return false;
      case WalletHistoryTransactionType.NFTSELL:
        return true;
    }
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
            decoration: BoxDecoration(color: AppColors.kWhite.withOpacity(0.5), shape: BoxShape.circle),
            child: Image.asset(
              ImageUtil.AUDIO_ICON,
              width: 35.w,
              height: 35.h,
              color: AppColors.kBlack.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNftPreviewWidget({required AssetType nftType, required String nftName, required String nftUrl, required String thumbnailUrl}) {
    return PreviewNFTGrid(
      assetType: nftType,
      on3dNFT: (BuildContext context) => Container(
        color: AppColors.k3DBackgroundColor,
        height: double.infinity,
        child: IgnorePointer(
          child: Nft3dWidget(
            url: nftUrl,
            cameraControls: false,
            backgroundColor: AppColors.k3DBackgroundColor,
          ),
        ),
      ),
      onPdfNFT: (BuildContext context) => PdfPlaceHolder(nftUrl: nftUrl, nftName: nftName, thumbnailUrl: thumbnailUrl),
      onVideoNFT: (BuildContext context) => VideoPlaceHolder(nftUrl: nftUrl, nftName: nftName, thumbnailUrl: thumbnailUrl),
      onImageNFT: (BuildContext context) =>
          CachedNetworkImage(placeholder: (context, url) => Shimmer(color: PylonsAppTheme.cardBackground, child: const SizedBox.expand()), imageUrl: nftUrl, fit: BoxFit.cover),
      onAudioNFT: (BuildContext context) => thumbnailUrl.isEmpty ? Image.asset(ImageUtil.AUDIO_BACKGROUND, fit: BoxFit.cover) : getAudioThumbnailFromUrl(thumbnailUrl: thumbnailUrl),
    );
  }

  Widget buildNFTDetailHeader({required TxDetailArguments args}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 30.h),
      child: SizedBox(
        height: 70.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 70.h,
              width: 70.h,
              child: buildNftPreviewWidget(
                nftType: args.nftType,
                nftUrl: args.nftUrl,
                thumbnailUrl: args.nftThumbnailUrl,
                nftName: args.recipe.name,
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  args.transactionEnum.name,
                  style: _titleTextStyle.copyWith(fontSize: 15.sp),
                ),
                Text(
                  args.recipe.id.trimString(stringTrimConstantMax),
                  style: _titleTextStyle.copyWith(fontSize: 11.sp),
                ),
              ],
            ),
            const Spacer(),
            Expanded(
              child: Text(
                "${getTxTypeFlag(txType: args.transactionEnum) ? "+" : "-"} ${args.price}",
                style: TextStyle(
                    color: getTxTypeFlag(txType: args.transactionEnum) ? AppColors.kBlack : AppColors.kDarkRed, fontFamily: kUniversalFontFamily, fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  Map<String, String> transactionDetailBodyMap({required TxDetailArguments txArgs}) {
    return {
      "nft_title".tr(): txArgs.recipe.name,
      "creator".tr(): txArgs.creator,
      "seller".tr(): txArgs.seller,
      "buyer".tr(): txArgs.buyer,
      "txId".tr(): txArgs.txID,
      "transaction_time".tr(): txArgs.transactionTime,
      "currency".tr(): txArgs.currency,
      "price".tr(): txArgs.price,
    };
  }

  Padding buildTxDetailBody({required TxDetailArguments txArgs}) {
    final txDetailMap = transactionDetailBodyMap(txArgs: txArgs);

    final detailList = txDetailMap.entries.map((element) => buildRow(key: element.key, value: element.value)).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.h),
      child: Column(children: detailList),
    );
  }

  Color getColor(String key) {
    if (key == "creator".tr() || key == "seller".tr() || key == "buyer".tr()) {
      return AppColors.kTradeReceiptTextColor;
    }
    return AppColors.kBlack;
  }

  Row buildRow({required String key, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(key, style: _titleTextStyle.copyWith(fontSize: 13.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 20.h),
        Text(value.trimString(stringTrimConstantMax), style: _titleTextStyle.copyWith(fontSize: 13.sp, fontWeight: FontWeight.bold, color: getColor(key))),
      ],
    );
  }

  bool isCollectionButtonEnabled() {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments! as TxDetailArguments;

    return Scaffold(
      body: Container(
        height: 1.sh,
        width: 1.sw,
        color: AppColors.kWhite,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 60.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios_sharp,
                          size: 25.r,
                        )),
                    Text(
                      'details'.tr(),
                      style: _titleTextStyle,
                    ),
                    SizedBox(
                      width: 40.w,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                buildNFTDetailHeader(args: args),
                buildTxDetailBody(txArgs: args),
              ],
            ),
            Positioned(
              bottom: 20.h,
              left: 20.w,
              right: 20.w,
              child: BlueClippedButton(
                enabled: isCollectionButtonEnabled(),
                onTap: () {
                  if (!isCollectionButtonEnabled()) {
                    return;
                  }
                  GetIt.I.get<HomeProvider>().changeTabs(0);
                  Navigator.pop(context);
                },
                text: "view_in_collection".tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

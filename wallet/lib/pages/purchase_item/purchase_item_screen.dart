import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/nft_3d_asset.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/nft_image_asset.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/pdf_viewer.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/tab_fields.dart';
import 'package:pylons_wallet/pages/gestures_for_detail_screen.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/owner_purchase_view_common/qr_code_screen.dart';
import 'package:pylons_wallet/pages/purchase_item/clipper/buy_now_clipper.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart' show PurchaseItemViewModel;
import 'package:pylons_wallet/pages/purchase_item/widgets/buy_nft_button.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/pay_now_dialog.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/purchase_audio_widget.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/purchase_video_player_screen.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/purchase_video_progress_widget.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/trade_receipt_dialog.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/transaction_complete_dialog.dart';
import 'package:pylons_wallet/utils/clipper_utils.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:pylons_wallet/utils/enums.dart' as enums;
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:pylons_wallet/utils/read_more.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

import '../../modules/Pylonstech.pylons.pylons/module/client/pylons/execution.pb.dart';

/// Sending NFT instead of viewmodel because the share plugin tends to rebuild this screen
/// Which creates two instance of view model
class PurchaseItemScreen extends StatefulWidget {
  final NFT nft;

  const PurchaseItemScreen({Key? key, required this.nft}) : super(key: key);

  @override
  State<PurchaseItemScreen> createState() => _PurchaseItemScreenState();
}

class _PurchaseItemScreenState extends State<PurchaseItemScreen> {
  final viewModel = sl<PurchaseItemViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.setNFT(widget.nft);
    viewModel.logEvent();

    scheduleMicrotask(() {
      viewModel.initializeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: WillPopScope(
          onWillPop: () async {
            viewModel.destroyPlayers();
            return true;
          },
          child: const PurchaseItemContent()),
    );
  }
}

class PurchaseItemContent extends StatefulWidget {
  const PurchaseItemContent({
    Key? key,
  }) : super(key: key);

  @override
  _PurchaseItemContentState createState() => _PurchaseItemContentState();
}

class _PurchaseItemContentState extends State<PurchaseItemContent> {
  bool _showPay = false;

  final GlobalKey key = GlobalKey();
  final myBottomDrawerController = BottomDrawerController();

  Widget getTypeWidget(PurchaseItemViewModel viewModel) {
    switch (viewModel.nft.assetType) {
      case AssetType.Audio:
        return getAudioWidget(thumbnailUrl: viewModel.nft.thumbnailUrl, viewModel: viewModel);
      case AssetType.Image:
        return NftImageWidget(url: viewModel.nft.url, opacity: viewModel.isViewingFullNft ? 0.0 : 0.4);
      case AssetType.Video:
        return PurchaseVideoPlayerScreen(nft: viewModel.nft);
      case AssetType.Pdf:
        return Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: PdfViewer(
            fileUrl: viewModel.nft.url,
          ),
        );
      case AssetType.ThreeD:
        return Container(
          color: Colors.grey.shade200,
          height: double.infinity,
          child: Nft3dWidget(
            url: viewModel.nft.url,
            cameraControls: true,
            backgroundColor: AppColors.kBlack,
          ),
        );

      default:
        return NftImageWidget(url: viewModel.nft.url, opacity: viewModel.isViewingFullNft ? 0.0 : 0.4);
    }
  }

  Widget getAudioWidget({required String thumbnailUrl, required PurchaseItemViewModel viewModel}) {
    if (thumbnailUrl.isEmpty) {
      return Image.asset(
        ImageUtil.AUDIO_BACKGROUND,
        fit: BoxFit.contain,
        height: MediaQuery.of(context).size.height,
      );
    }

    return NftImageWidget(
      url: thumbnailUrl,
      opacity: viewModel.isViewingFullNft ? 0.0 : 0.4,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PurchaseItemViewModel>();

    return Scaffold(
        backgroundColor: AppColors.kBlack,
        body: GesturesForDetailsScreen(
          nft: viewModel.nft,
          viewModel: viewModel,
          screen: DetailScreen.purchaseScreen,
          tapUp: (context) => onTapUp,
          child: Stack(
            children: [
              getTypeWidget(viewModel),
              Visibility(
                visible: !viewModel.isViewingFullNft,
                child: Padding(
                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: MediaQuery.of(context).viewPadding.top),
                  child: SizedBox(
                    height: 100.h,
                    width: double.infinity,
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          viewModel.destroyPlayers();
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          SVGUtil.OWNER_BACK_ICON,
                          height: 25.h,
                        ),
                      ),
                      trailing: const SizedBox(),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !viewModel.isViewingFullNft,
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: OwnerBottomDrawer(),
                ),
              )
            ],
          ),
        ));
  }

//detect card's outside tap
  void onTapUp(BuildContext context, TapUpDetails details) {
    if (key.currentContext != null) {
      // This should generally not be null, but it could be null in test cases, conceivably, so let's not crash
      final containerBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (containerBox != null) {
        final isHit = containerBox.hitTest(BoxHitTestResult(), position: details.localPosition);
        if (_showPay == true && !isHit) {
          setState(() {
            _showPay = false;
          });
        }
      }
    }
  }
}

class OwnerBottomDrawer extends StatefulWidget {
  const OwnerBottomDrawer({Key? key}) : super(key: key);

  @override
  State<OwnerBottomDrawer> createState() => _OwnerBottomDrawerState();
}

class _OwnerBottomDrawerState extends State<OwnerBottomDrawer> {
  bool liked = false;
  bool collapsed = true;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  Widget getProgressWidget(PurchaseItemViewModel viewModel) {
    switch (viewModel.nft.assetType) {
      case AssetType.Audio:
        return PurchaseAudioWidget(url: viewModel.nft.url);
      case AssetType.Image:
        break;
      case AssetType.Video:
        return PurchaseVideoProgressWidget(url: viewModel.nft.url);

      default:
        return const SizedBox.shrink();
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PurchaseItemViewModel>();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (viewModel.collapsed) ...[
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w, top: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 60.h,
                    child: Row(
                      children: [
                        Expanded(child: _title(nft: viewModel.nft, owner: viewModel.nft.type == NftType.TYPE_RECIPE ? viewModel.nft.creator : viewModel.nft.owner)),
                        IconButton(
                          key: const Key(kKeyboardUpButtonKeyValue),
                          icon: Icon(
                            Icons.keyboard_arrow_up,
                            size: 32.h,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            viewModel.toChangeCollapse();
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  getProgressWidget(viewModel),
                  SizedBox(
                    height: 60.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20.w,
                        ),
                        buildLikeColumn(viewModel: viewModel),
                        SizedBox(
                          width: 20.w,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final Size size = MediaQuery.of(context).size;
                            context.read<PurchaseItemViewModel>().shareNFTLink(size: size);
                          },
                          child: Container(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: SvgPicture.asset(
                              SVGUtil.OWNER_SHARE,
                              height: 20.h,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        const Spacer(),

                        /// BUY NFT BUTTON
                        if (viewModel.showBuyNowButton(isPlatformAndroid: Platform.isAndroid))
                          BuyNFTButton(
                            onTapped: () async {
                              bool balancesFetchResult = true;
                              if (viewModel.nft.price != kZeroInt) {
                                final balancesEither = await viewModel.shouldShowSwipeToBuy(
                                  selectedDenom: viewModel.nft.denom,
                                  requiredAmount: double.parse(viewModel.nft.price) / kBigIntBase,
                                );

                                if (balancesEither.isLeft()) {
                                  balancesEither.swap().getOrElse(() => '').show();
                                  return;
                                }

                                balancesFetchResult = balancesEither.getOrElse(() => false);
                              }

                              viewModel.addLogForCart();

                              final PayNowDialog payNowDialog = PayNowDialog(
                                  buildContext: context,
                                  nft: viewModel.nft,
                                  purchaseItemViewModel: viewModel,
                                  onPurchaseDone: (txData) {
                                    showTransactionCompleteDialog(execution: txData);
                                  },
                                  shouldBuy: balancesFetchResult);
                              payNowDialog.show();
                            },
                            nft: viewModel.nft,
                          ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ] else ...[
            buildOpenedSheet(context, viewModel)
          ]
        ],
      ),
    );
  }

  Widget soldOutButton(PurchaseItemViewModel viewModel) {
    return ClipPath(
      clipper: BuyClipper(),
      child: Container(
        width: 200.w,
        height: 60.h,
        color: AppColors.kDarkRed.withOpacity(0.5),
        child: Row(
          children: [
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  kSoldOut,
                  style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 8.w,
                ),
                const SizedBox(),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Column buildLikeColumn({required PurchaseItemViewModel viewModel}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: GestureDetector(
              onTap: () async {
                await viewModel.updateLikeStatus(recipeId: viewModel.nft.recipeID, cookBookID: viewModel.nft.cookbookID);
              },
              child: viewModel.isLiking ? getLikingLoader() : getLikeIcon(likedByMe: viewModel.likedByMe)),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          viewModel.likesCount.toString(),
          style: TextStyle(color: Colors.white, fontSize: 10.sp),
        ),
      ],
    );
  }

  Widget getLikingLoader() {
    return SizedBox(
      height: 15.h,
      width: 15.h,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.kWhite),
      ),
    );
  }

  Widget getLikeIcon({required bool likedByMe}) {
    return SizedBox(
      height: 20.h,
      width: 20.h,
      child: Image.asset(
        'assets/images/icons/${likedByMe ? 'like_full' : 'like'}.png',
        fit: BoxFit.fill,
        color: likedByMe ? AppColors.kDarkRed : Colors.white,
      ),
    );
  }

  Stack buildOpenedSheet(BuildContext context, PurchaseItemViewModel viewModel) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: ClipPath(
            clipper: RightTriangleClipper(orientation: enums.Orientation.Orientation_SW),
            child: Container(
              color: AppColors.kDarkRed,
              height: 50,
              width: 50,
              child: Center(
                  child: IconButton(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(
                  bottom: 8,
                  left: 8,
                ),
                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                onPressed: () {
                  viewModel.toChangeCollapse();
                },
                iconSize: 32,
                color: Colors.white,
              )),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: ClipPath(
              clipper: RightTriangleClipper(orientation: enums.Orientation.Orientation_NE),
              child: Container(
                color: AppColors.kDarkRed,
                height: 30.h,
                width: 30.w,
              ),
            ),
          ),
        ),
        ClipPath(
          clipper: ExpandedViewClipper(),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.black54,
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(nft: viewModel.nft, owner: viewModel.nft.type == NftType.TYPE_RECIPE ? viewModel.nft.creator : viewModel.nft.owner),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(SVGUtil.OWNER_VIEWS),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        viewModel.viewsCount == 1 ? "${viewModel.viewsCount.toString()} $kView" : "${viewModel.viewsCount.toString()} $kViews",
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  if (viewModel.nft.assetType == AssetType.Audio) ...[
                    Container(
                      width: 250.w,
                      color: AppColors.kWhite.withOpacity(0.2),
                      child: PurchaseAudioWidget(url: viewModel.nft.url),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                  if (viewModel.nft.assetType == AssetType.Video) ...[
                    Container(
                      width: 250.w,
                      color: AppColors.kWhite.withOpacity(0.2),
                      child: PurchaseVideoProgressWidget(url: viewModel.nft.url),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                  if (viewModel.nft.hashtags.isNotEmpty)
                    Wrap(
                        spacing: 10.w,
                        children: List.generate(
                            viewModel.hashtagList.length,
                            (index) => SizedBox(
                                  child: DetectableText(
                                    text: "#${viewModel.hashtagList[index]}",
                                    detectionRegExp: detectionRegExp()!,
                                    detectedStyle: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.kCopyColor,
                                    ),
                                    basicStyle: TextStyle(
                                      fontSize: 20.sp,
                                    ),
                                    onTap: (tappedText) {},
                                  ),
                                ))),
                  SizedBox(
                    height: 10.h,
                  ),
                  ReadMoreText(
                    viewModel.nft.description,
                    trimExpandedText: "collapse".tr(),
                    trimCollapsedText: "read_more".tr(),
                    moreStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.kCopyColor),
                    lessStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.kCopyColor),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 85,
                          child: Column(
                            children: [
                              TabField(
                                name: 'ownership'.tr(),
                                icon: 'trophy',
                                nft: viewModel.nft,
                                owner: viewModel.nft.owner,
                                NftOwnershipHistoryList: const [],
                              ),
                              SizedBox(height: 10.h),
                              TabField(
                                name: "nft_detail".tr(),
                                icon: 'detail',
                                nft: viewModel.nft,
                                owner: viewModel.nft.owner,
                                NftOwnershipHistoryList: const [],
                              ),
                              SizedBox(height: 10.h),
                              if (viewModel.nft.type != NftType.TYPE_RECIPE)
                                TabField(name: "history".tr(), icon: 'history', nft: viewModel.nft, owner: viewModel.nft.owner, NftOwnershipHistoryList: viewModel.nftOwnershipHistoryList),
                              SizedBox(height: 50.h),
                              if (viewModel.nft.amountMinted >= viewModel.nft.quantity) soldOutButton(viewModel)
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 15,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await viewModel.updateLikeStatus(recipeId: viewModel.nft.recipeID, cookBookID: viewModel.nft.cookbookID);
                                    },
                                    child: viewModel.isLiking ? getLikingLoader() : getLikeIcon(likedByMe: viewModel.likedByMe),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    viewModel.likesCount.toString(),
                                    style: TextStyle(color: Colors.white, fontSize: 10.sp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => QRCodeScreen(
                                            nft: viewModel.nft,
                                          ));
                                },
                                child: SvgPicture.asset(
                                  SVGUtil.QR_ICON,
                                  height: 20.h,
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final Size size = MediaQuery.of(context).size;
                                  context.read<PurchaseItemViewModel>().shareNFTLink(size: size);
                                },
                                child: SvgPicture.asset(
                                  SVGUtil.OWNER_SHARE,
                                  height: 20.h,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  /// BUY NFT BUTTON
                  if (viewModel.showBuyNowButton(isPlatformAndroid: Platform.isAndroid))
                    BuyNFTButton(
                      onTapped: () async {
                        bool balancesFetchResult = true;
                        if (viewModel.nft.price != kZeroInt) {
                          final balancesEither = await viewModel.shouldShowSwipeToBuy(
                            selectedDenom: viewModel.nft.denom,
                            requiredAmount: double.parse(viewModel.nft.price) / kBigIntBase,
                          );

                          if (balancesEither.isLeft()) {
                            balancesEither.swap().getOrElse(() => '').show();
                            return;
                          }

                          balancesFetchResult = balancesEither.getOrElse(() => false);
                        }

                        viewModel.addLogForCart();

                        final PayNowDialog payNowDialog = PayNowDialog(
                            buildContext: context,
                            nft: viewModel.nft,
                            purchaseItemViewModel: viewModel,
                            onPurchaseDone: (txData) {
                              showTransactionCompleteDialog(execution: txData);
                            },
                            shouldBuy: balancesFetchResult);
                        payNowDialog.show();
                      },
                      nft: viewModel.nft,
                    ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _title({required NFT nft, required String owner}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                nft.name,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (nft.type == NftType.TYPE_RECIPE)
              Padding(
                padding: EdgeInsets.only(
                  bottom: 2.h,
                ),
                child: Text(
                  ' (${nft.amountMinted} of ${nft.quantity})',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.sp),
                ),
              ),
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "created_by".tr(),
                style: TextStyle(color: Colors.white, fontSize: 18.sp),
              ),
              TextSpan(text: owner, style: TextStyle(color: const Color(0xFFB6B6E8), fontSize: 18.sp)),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SvgPicture.asset(
                    SVGUtil.OWNER_VERIFIED_ICON,
                    height: 15.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String getTransactionTimeStamp(int? time) {
    final formatter = DateFormat('MMM dd yyyy HH:mm');
    if (time == null) {
      return "${formatter.format(DateTime.now().toUtc())} $kUTC";
    }

    final int timeStamp = time * kDateConverterConstant;
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp, isUtc: true);
    return "${formatter.format(dateTime)} $kUTC";
  }

  void showTransactionCompleteDialog({required Execution execution}) {
    final viewModel = context.read<PurchaseItemViewModel>();

    var price = double.parse(viewModel.nft.price);
    final fee = double.parse(viewModel.nft.price) * 0.1;
    price = price - fee;

    final txId = execution.hasId() ? execution.id : "";

    final txTime = getTransactionTimeStamp(execution.hasTxTime() ? execution.txTime.toInt() : null);

    final model = TradeReceiptModel(
      tradeId: viewModel.nft.tradeID,
      pylonsFee: viewModel.nft.ibcCoins.getCoinWithDenominationAndSymbol(fee.toString(), showDecimal: true),
      price: viewModel.nft.ibcCoins.getCoinWithDenominationAndSymbol(price.toString()),
      createdBy: viewModel.nft.creator,
      currency: viewModel.nft.ibcCoins.getAbbrev(),
      soldBy: viewModel.nft.owner.isEmpty ? viewModel.nft.creator : viewModel.nft.owner,
      transactionTime: txTime,
      total: viewModel.nft.ibcCoins.getCoinWithDenominationAndSymbol(viewModel.nft.price, showDecimal: true),
      nftName: viewModel.nft.name,
      transactionID: txId,
    );

    final TradeCompleteDialog tradeCompleteDialog = TradeCompleteDialog(
        model: model,
        context: context,
        onBackPressed: () {
          showReceiptDialog(model);
        });
    tradeCompleteDialog.show();
  }

  void showReceiptDialog(TradeReceiptModel model) {
    final TradeReceiptDialog tradeReceiptDialog = TradeReceiptDialog(context: context, model: model);
    tradeReceiptDialog.show();
  }
}

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
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/nft_3d_asset.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/nft_image_asset.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/pdf_viewer.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/tab_fields.dart';
import 'package:pylons_wallet/pages/gestures_for_detail_screen.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/purchase_item/clipper/buy_now_clipper.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart' show PurchaseItemViewModel;
import 'package:pylons_wallet/pages/purchase_item/widgets/buy_nft_button.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/pay_now_dialog.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/purchase_audio_widget.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/purchase_video_player_screen.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/purchase_video_progress_widget.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/trade_receipt_dialog.dart';
import 'package:pylons_wallet/pages/purchase_item/widgets/transaction_complete_dialog.dart';
import 'package:pylons_wallet/pages/settings/screens/submit_feedback.dart';
import 'package:pylons_wallet/utils/clipper_utils.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:pylons_wallet/utils/enums.dart' as enums;
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:pylons_wallet/utils/read_more.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

import '../../generated/locale_keys.g.dart';
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
        child: const PurchaseItemContent(),
      ),
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
            showLoader: true,
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
                padding: EdgeInsets.only(
                  left: 8.w,
                  right: 8.w,
                  bottom: 8.h,
                  top: MediaQuery.of(context).viewPadding.top.h,
                ),
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
                    trailing: GestureDetector(
                      onTap: () {
                        final SubmitFeedback submitFeedbackDialog = SubmitFeedback(context: context);
                        submitFeedbackDialog.show();
                      },
                      child: SvgPicture.asset(
                        SVGUtil.OWNER_REPORT,
                        height: 25.h,
                      ),
                    ),
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
      ),
    );
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title(nft: viewModel.nft, owner: viewModel.nft.type == NftType.TYPE_RECIPE ? viewModel.nft.creator : viewModel.nft.owner),
                        SizedBox(
                          height: 18.h,
                        ),

                        /// BUY NFT BUTTON
                        if (viewModel.showBuyNowButton(isPlatformAndroid: Platform.isAndroid))
                          BuyNFTButton(
                            onTapped: () async {
                              if (viewModel.accountPublicInfo == null) {
                                LocaleKeys.create_an_account_first.tr().show();
                                Navigator.of(context).pushNamed(RouteUtil.ROUTE_ONBOARDING);
                                return;
                              }
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
                  Column(
                    children: [
                      SvgPicture.asset(
                        SVGUtil.OWNER_VIEWS_BOLD,
                        width: 20.w,
                        height: 15.h,
                      ),
                      SizedBox(
                        width: 4.5.w,
                      ),
                      Text(
                        viewModel.viewsCount.toString(),
                        style: TextStyle(color: AppColors.kWhite, fontSize: 11.sp, fontFamily: kUniversalFontFamily, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      buildLikeColumn(viewModel: viewModel),
                      SizedBox(
                        height: 18.h,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (viewModel.accountPublicInfo == null) {
                            Navigator.of(context).pushNamed(RouteUtil.ROUTE_ONBOARDING);
                            return;
                          }
                          final Size size = MediaQuery.of(context).size;
                          context.read<PurchaseItemViewModel>().shareNFTLink(size: size);
                        },
                        child: Container(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: SvgPicture.asset(
                            SVGUtil.OWNER_SHARE,
                            height: 15.h,
                            width: 15.w,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      IconButton(
                        key: const Key(kKeyboardUpButtonKeyValue),
                        icon: Icon(
                          Icons.keyboard_arrow_up,
                          size: 28.h,
                          color: AppColors.kWhite,
                        ),
                        onPressed: () {
                          viewModel.toChangeCollapse();
                        },
                      )
                    ],
                  ),
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
                  style: TextStyle(color: AppColors.kWhite, fontSize: 18.sp, fontWeight: FontWeight.bold),
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
                if (viewModel.accountPublicInfo == null) return;
                await viewModel.updateLikeStatus(recipeId: viewModel.nft.recipeID, cookBookID: viewModel.nft.cookbookID);
              },
              child: viewModel.isLiking ? getLikingLoader() : getLikeIcon(likedByMe: viewModel.likedByMe)),
        ),
        SizedBox(
          height: 2.8.h,
        ),
        Text(
          viewModel.likesCount.toString(),
          style: TextStyle(color: AppColors.kWhite, fontSize: 10.sp, fontFamily: kUniversalFontFamily, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget getLikingLoader() {
    return SizedBox(
      height: 15.h,
      width: 15.w,
      child: const CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.kWhite),
      ),
    );
  }

  Widget getLikeIcon({required bool likedByMe}) {
    return SizedBox(
      height: 20.r,
      width: 20.r,
      child: Image.asset(
        'assets/images/icons/${likedByMe ? 'like_full' : 'like_bold'}.png',
        fit: BoxFit.fill,
        color: likedByMe ? AppColors.kDarkRed : AppColors.kWhite,
      ),
    );
  }

  Stack buildOpenedSheet(BuildContext context, PurchaseItemViewModel viewModel) {
    return Stack(
      key: const Key(kPurchaseItemBottomSheetKey),
      children: [
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
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ReadMoreText(
                    viewModel.nft.description,
                    trimExpandedText: LocaleKeys.collapse.tr(),
                    trimCollapsedText: LocaleKeys.read_more.tr(),
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
                                name: LocaleKeys.ownership.tr(),
                                icon: 'trophy',
                                nft: viewModel.nft,
                                owner: viewModel.nft.owner,
                                nftOwnershipHistoryList: const [],
                                isExpanded: viewModel.isOwnershipExpanded,
                                onChangeTab: viewModel.onChangeTab,
                              ),
                              SizedBox(height: 10.h),
                              TabField(
                                name: LocaleKeys.nft_detail.tr(),
                                icon: 'detail',
                                nft: viewModel.nft,
                                owner: viewModel.nft.owner,
                                nftOwnershipHistoryList: const [],
                                isExpanded: viewModel.isDetailsExpanded,
                                onChangeTab: viewModel.onChangeTab,
                              ),
                              SizedBox(height: 10.h),
                              if (viewModel.nft.type == NftType.TYPE_RECIPE && viewModel.nftOwnershipHistoryList.isNotEmpty)
                                TabField(
                                  name: LocaleKeys.history.tr(),
                                  icon: 'history',
                                  nft: viewModel.nft,
                                  owner: viewModel.nft.owner,
                                  nftOwnershipHistoryList: viewModel.nftOwnershipHistoryList,
                                  isExpanded: viewModel.isHistoryExpanded,
                                  onChangeTab: viewModel.onChangeTab,
                                ),
                              SizedBox(height: 50.h),
                              if (viewModel.nft.amountMinted >= viewModel.nft.quantity) soldOutButton(viewModel)
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 15,
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                SVGUtil.OWNER_VIEWS_BOLD,
                                width: 15.w,
                                height: 15.h,
                              ),
                              SizedBox(
                                height: 4.5.h,
                              ),
                              Text(
                                viewModel.viewsCount.toString(),
                                style: TextStyle(color: AppColors.kWhite, fontSize: 11.sp, fontFamily: kUniversalFontFamily, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 18.h,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (viewModel.accountPublicInfo == null) return;
                                  await viewModel.updateLikeStatus(recipeId: viewModel.nft.recipeID, cookBookID: viewModel.nft.cookbookID);
                                },
                                child: viewModel.isLiking ? getLikingLoader() : getLikeIcon(likedByMe: viewModel.likedByMe),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                viewModel.likesCount.toString(),
                                style: TextStyle(color: AppColors.kWhite, fontSize: 10.sp),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (viewModel.accountPublicInfo == null) {
                                    Navigator.of(context).pushNamed(RouteUtil.ROUTE_ONBOARDING);
                                    return;
                                  }
                                  final Size size = MediaQuery.of(context).size;
                                  context.read<PurchaseItemViewModel>().shareNFTLink(size: size);
                                },
                                child: SvgPicture.asset(
                                  SVGUtil.OWNER_SHARE,
                                  height: 15.h,
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
                      key: const Key(kExpandedBuyButtonKeyValue),
                      onTapped: () async {
                        if (viewModel.accountPublicInfo == null) {
                          LocaleKeys.create_an_account_first.tr().show();
                          Navigator.of(context).pushNamed(RouteUtil.ROUTE_ONBOARDING);
                          return;
                        }
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
        ),
        Align(
          alignment: Alignment.topRight,
          child: ClipPath(
            clipper: RightTriangleClipper(orientation: enums.Orientation.Orientation_SW),
            child: Container(
              color: AppColors.kDarkRed,

              height: 55.r,
              width: 55.r,
              child: Center(
                child: IconButton(
                  key: const Key(kCloseBottomSheetKey),
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(

                    bottom: 15.h,
                    left: isTablet ? 16.w : 20.w,
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  onPressed: () {
                    viewModel.toChangeCollapse();
                  },
                  iconSize: 32.h,
                  color: AppColors.kWhite,
                ),
              ),
            ),
          ),
        ),
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
                style: TextStyle(color: AppColors.kWhite, fontSize: 18.sp, fontFamily: kUniversalFontFamily, fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 3.h,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.created_by.tr(),
                style: TextStyle(color: AppColors.kWhite, fontSize: 11.sp),
              ),
              TextSpan(text: owner, style: TextStyle(color: AppColors.kCopyColor, fontSize: 13.sp)),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SvgPicture.asset(
                    SVGUtil.OWNER_VERIFIED_ICON,
                    height: 12.h,
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
      },
    );
    tradeCompleteDialog.show();
  }

  void showReceiptDialog(TradeReceiptModel model) {
    final TradeReceiptDialog tradeReceiptDialog = TradeReceiptDialog(context: context, model: model);
    tradeReceiptDialog.show();
  }
}

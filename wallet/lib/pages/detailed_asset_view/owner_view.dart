import 'dart:async';
import 'dart:ui';

import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view_view_model.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/nft_3d_asset.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/nft_image_asset.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/owner_audio_widget.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/owner_video_player_screen.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/owner_video_progress_widget.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/pdf_viewer.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/tab_fields.dart';
import 'package:pylons_wallet/pages/gestures_for_detail_screen.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/owner_purchase_view_common/qr_code_screen.dart';
import 'package:pylons_wallet/pages/settings/screens/submit_feedback.dart';
import 'package:pylons_wallet/utils/clipper_utils.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart' as enums;
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:pylons_wallet/utils/read_more.dart';
import 'package:pylons_wallet/utils/svg_util.dart';


class OwnerView extends StatefulWidget {
  final NFT nft;
  const OwnerView({required this.nft, Key? key}) : super(key: key);

  @override
  State<OwnerView> createState() => _OwnerViewState();
}

class _OwnerViewState extends State<OwnerView> {
  OwnerViewViewModel ownerViewViewModel = GetIt.I.get();

  @override
  void initState() {
    super.initState();

    ownerViewViewModel.nft = widget.nft;

    ownerViewViewModel.logEvent();
    scheduleMicrotask(() {
      ownerViewViewModel.initializeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ownerViewViewModel.destroyPlayers();
        return true;
      },
      child: ChangeNotifierProvider.value(
        value: ownerViewViewModel,
        builder: (_, __) => Scaffold(
          backgroundColor: AppColors.kBlack,
          body: const OwnerViewContent(),
        ),
      ),
    );
  }
}

class OwnerViewContent extends StatefulWidget {
  const OwnerViewContent({Key? key}) : super(key: key);

  @override
  State<OwnerViewContent> createState() => _OwnerViewContentState();
}

class _OwnerViewContentState extends State<OwnerViewContent> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OwnerViewViewModel>();
    return GesturesForDetailsScreen(
      key: const ValueKey(kOwnerViewKeyValue),
      screen: DetailScreen.ownerScreen,
      viewModel: viewModel,
      nft: viewModel.nft,
      child: Stack(
        children: [
          getTypeWidget(),
          if (isUserNotViewingFullNft(viewModel))
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: MediaQuery.of(context).viewPadding.top),
              child: SizedBox(
                height: 100.h,
                width: double.infinity,
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () async {
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
          if (isUserNotViewingFullNft(viewModel)) const Align(key: ValueKey(kOwnerViewDrawerKeyValue), alignment: Alignment.bottomCenter, child: OwnerBottomDrawer())
        ],
      ),
    );
  }

  Widget getAudioWidget({required String thumbnailUrl}) {
    final viewModel = context.read<OwnerViewViewModel>();
    return thumbnailUrl.isEmpty
        ? Image.asset(
            ImageUtil.AUDIO_BACKGROUND,
            fit: BoxFit.contain,
            height: MediaQuery.of(context).size.height,
          )
        : NftImageWidget(
            url: viewModel.nft.thumbnailUrl,
            opacity: viewModel.isViewingFullNft ? 0.0 : 0.4,
          );
  }

  Widget getTypeWidget() {
    final viewModel = context.read<OwnerViewViewModel>();
    switch (viewModel.nft.assetType) {
      case AssetType.Audio:
        return getAudioWidget(thumbnailUrl: viewModel.nft.thumbnailUrl);
      case AssetType.Image:
        return NftImageWidget(url: viewModel.nft.url, opacity: viewModel.isViewingFullNft ? 0.0 : 0.4);
      case AssetType.Video:
        return OwnerVideoPlayerScreen(nft: viewModel.nft);
      case AssetType.Pdf:
        return PdfViewer(
          fileUrl: viewModel.nft.url,
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
        return NftImageWidget(
          url: viewModel.nft.url,
          opacity: viewModel.isViewingFullNft ? 0.0 : 0.4,
        );
    }
  }

  bool isUserNotViewingFullNft(OwnerViewViewModel viewModel) => !viewModel.isViewingFullNft;
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

  Widget getProgressWidget() {
    final viewModel = context.read<OwnerViewViewModel>();
    switch (viewModel.nft.assetType) {
      case AssetType.Audio:
        return OwnerAudioWidget(url: viewModel.nft.url);
      case AssetType.Image:
        break;
      case AssetType.Video:
        return OwnerVideoProgressWidget(url: viewModel.nft.url);

      default:
        return const SizedBox.shrink();
    }
    return const SizedBox.shrink();
  }

  Widget getLikingLoader() {
    return SizedBox(
      height: 20.h,
      width: 20.h,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.kWhite),
      ),
    );
  }

  Widget getLikeIcon({required bool likedByMe}) {
    return Image.asset(
      'assets/images/icons/${likedByMe ? 'like_full' : 'like'}.png',
      height: 20.h,
      color: likedByMe ? AppColors.kDarkRed : Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OwnerViewViewModel>();
    final ibcEnumCoins = viewModel.nft.ibcCoins;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (viewModel.collapsed) ...[
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w, top: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60.h,
                    child: Row(
                      children: [
                        Expanded(
                          child: _title(
                            nft: viewModel.nft,
                            owner: viewModel.nft.type == NftType.TYPE_RECIPE ? "you".tr() : viewModel.nft.creator,
                          ),
                        ),
                        IconButton(
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
                    height: 20,
                  ),
                  getProgressWidget(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          if (viewModel.nft.type != NftType.TYPE_ITEM)
                            Text("${ibcEnumCoins.getCoinWithProperDenomination(viewModel.nft.price)} ${ibcEnumCoins.getAbbrev()}",
                                style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold))
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 40.w,
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              final Size size = MediaQuery.of(context).size;

                              context.read<OwnerViewViewModel>().shareNFTLink(size: size);
                            },
                            child: SvgPicture.asset(
                              SVGUtil.OWNER_SHARE,
                              height: 20.h,
                            ),
                          ),
                          SizedBox(
                            height: 7.h,
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ] else ...[
            Stack(
              key: const ValueKey(kOwnerViewBottomSheetKeyValue),
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
                          _title(nft: viewModel.nft, owner: viewModel.nft.type == NftType.TYPE_RECIPE ? "you".tr() : viewModel.nft.creator),
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
                                viewModel.viewsCount == 1 ? "${viewModel.viewsCount.toString()} ${'view'.tr()}" : "${viewModel.viewsCount.toString()} ${'views'.tr()}",
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
                              child: OwnerAudioWidget(url: viewModel.nft.url),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                          if (viewModel.nft.assetType == AssetType.Video) ...[
                            Container(
                              width: 250.w,
                              color: AppColors.kWhite.withOpacity(0.2),
                              child: OwnerVideoProgressWidget(url: viewModel.nft.url),
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
                                      color: AppColors.kHashtagColor,
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
                                        name: "ownership".tr(),
                                        icon: 'trophy',
                                        nft: viewModel.nft,
                                        owner: viewModel.owner,
                                        NftOwnershipHistoryList: const [],
                                      ),
                                      SizedBox(height: 10.h),
                                      TabField(
                                        name: "nft_detail".tr(),
                                        icon: 'detail',
                                        nft: viewModel.nft,
                                        owner: viewModel.owner,
                                        NftOwnershipHistoryList: const [],
                                      ),
                                      SizedBox(height: 10.h),
                                      if (viewModel.nft.type != NftType.TYPE_RECIPE)
                                        TabField(name: "history".tr(), icon: 'history', nft: viewModel.nft, owner: viewModel.nft.owner, NftOwnershipHistoryList: viewModel.nftOwnershipHistoryList),
                                      SizedBox(height: 30.h),
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
                                          IgnorePointer(
                                            ignoring: viewModel.isLiking,
                                            child: GestureDetector(
                                              onTap: () async {
                                                await viewModel.updateLikeStatus(cookBookID: viewModel.nft.cookbookID, recipeId: viewModel.nft.recipeID);
                                              },
                                              child: viewModel.isLiking ? getLikingLoader() : getLikeIcon(likedByMe: viewModel.likedByMe),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                            viewModel.likesCount.toString(),
                                            style: const TextStyle(color: Colors.white, fontSize: 12),
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
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          final Size size = MediaQuery.of(context).size;
                                          viewModel.shareNFTLink(size: size);
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
                          Row(
                            children: [
                              SizedBox(
                                width: 10.w,
                              ),
                              Column(
                                children: [
                                  if (viewModel.nft.type != NftType.TYPE_ITEM)
                                    Text("${ibcEnumCoins.getCoinWithProperDenomination(viewModel.nft.price)} ${ibcEnumCoins.getAbbrev()}",
                                        style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold))
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ]
        ],
      ),
    );
  }
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
            TextSpan(text: owner, style: TextStyle(color: AppColors.kCopyColor, fontSize: 18.sp)),
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

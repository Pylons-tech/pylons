import 'dart:io';
import 'dart:ui';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/screens/owner_view/viewmodel/owner_view_viewmodel.dart';
import 'package:easel_flutter/screens/owner_view/widgets/audio_progress_widget.dart';
import 'package:easel_flutter/screens/owner_view/widgets/gestures_for_owner_view.dart';
import 'package:easel_flutter/screens/owner_view/widgets/submit_feedback.dart';
import 'package:easel_flutter/screens/owner_view/widgets/tab_fields.dart';
import 'package:easel_flutter/screens/owner_view/widgets/video_progress_widget.dart';
import 'package:easel_flutter/screens/preview_nft/nft_video_progress_widget.dart';
import 'package:easel_flutter/utils/clipper_utils.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/read_more.dart';
import 'package:easel_flutter/widgets/audio_widget.dart';
import 'package:easel_flutter/widgets/image_widget.dart';
import 'package:easel_flutter/widgets/model_viewer.dart';
import 'package:easel_flutter/widgets/pdf_viewer.dart';
import 'package:easel_flutter/widgets/video_progress_widget.dart';
import 'package:easel_flutter/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:easel_flutter/utils/enums.dart' as enums;

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

    // ownerViewViewModel.logEvent();
    // scheduleMicrotask(() {
    //   ownerViewViewModel.initializeData();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: ChangeNotifierProvider.value(
        value: ownerViewViewModel,
        builder: (_, __) => const Scaffold(
          backgroundColor: EaselAppTheme.kBlack,
          body: OwnerViewContent(),
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
      // key: const ValueKey(kOwnerViewKeyValue),
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
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      SVGUtils.kBackIcon,
                      height: 25.h,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      final SubmitFeedback submitFeedbackDialog = SubmitFeedback(context: context);
                      submitFeedbackDialog.show();
                    },
                    child: SvgPicture.asset(
                      SVGUtils.kReportIcon,
                      height: 25.h,
                    ),
                  ),
                ),
              ),
            ),
          if (isUserNotViewingFullNft(viewModel))
            const Align(
              // key: ValueKey(kOwnerViewDrawerKeyValue),
              alignment: Alignment.bottomCenter,
              child: OwnerBottomDrawer(),
            )
        ],
      ),
    );
  }

  Widget getTypeWidget() {
    final viewModel = context.read<OwnerViewViewModel>();
    switch (viewModel.nft.assetType.toAssetTypeEnum()) {
      case AssetType.Audio:
        return AudioWidget(
          filePath: viewModel.nft.url.changeDomain(),
          previewFlag: false,
          fromOwnerScreen: true,
        );
      case AssetType.Image:
        return ImageWidget(
          filePath: viewModel.nft.url,
        );
      case AssetType.Video:
        return Center(
          child: VideoWidget(
            key: ValueKey(viewModel.nft.url.changeDomain()),
            filePath: viewModel.nft.url.changeDomain(),
            previewFlag: true,
            isForFile: false,
            isDarkMode: true,
          ),
        );
      case AssetType.Pdf:
        return PdfViewer(
          fileUrl: viewModel.nft.url,
          previewFlag: false,
        );
      case AssetType.ThreeD:
        return SizedBox(
          height: double.infinity,
          width: 1.sw,
          child: Model3dViewer(
            path: viewModel.nft.url.changeDomain(),
            isFile: false,
          ),
        );
      default:
        return ImageWidget(
          filePath: viewModel.nft.url,
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

  Widget getProgressWidget() {
    final viewModel = context.read<OwnerViewViewModel>();
    switch (viewModel.nft.assetType.toAssetTypeEnum()) {
      case AssetType.Audio:
        return OwnerAudioWidget(url: viewModel.nft.url);
      case AssetType.Image:
        break;
      case AssetType.Video:
        return const VideoProgressWidget(
          darkMode: true,
          isForFile: false,
        );
      // return OwnerVideoProgressWidget(url: viewModel.nft.url);
      default:
        return const SizedBox.shrink();
    }
    return const SizedBox.shrink();
  }

  Widget getLikingLoader() {
    return SizedBox(
      height: 20.h,
      width: 20.h,
      child: const CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(EaselAppTheme.kWhite),
      ),
    );
  }

  Widget getLikeIcon({required bool likedByMe}) {
    return Image.asset(
      'assets/images/icons/${likedByMe ? 'like_full' : 'like'}.png',
      height: 20.h,
      color: likedByMe ? EaselAppTheme.kLightRed : EaselAppTheme.kWhite,
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
                            owner: viewModel.nft.type.toNftTypeEnum() == NftType.TYPE_RECIPE ? "You" : viewModel.nft.creator,
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
                          if (viewModel.nft.type.toNftTypeEnum() != NftType.TYPE_ITEM)
                            Text(
                              "${ibcEnumCoins.toIBCCoinsEnum().getCoinWithProperDenomination(viewModel.nft.price)} ${ibcEnumCoins.toIBCCoinsEnum().getAbbrev()}",
                              style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold),
                            )
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 40.w,
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            // key: const Key(kShareNftButtonCollapsedKey),
                            onTap: () {
                              final Size size = MediaQuery.of(context).size;

                              // context.read<OwnerViewViewModel>().shareNFTLink(size: size);
                            },
                            child: SvgPicture.asset(
                              SVGUtils.kShareIcon,
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
              // key: const ValueKey(kOwnerViewBottomSheetKeyValue),
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: ClipPath(
                    clipper: RightTriangleOwnerViewClipper(orientation: enums.Orientation.Orientation_SW),
                    child: Container(
                      color: EaselAppTheme.kLightRed,
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
                      clipper: RightTriangleOwnerViewClipper(orientation: enums.Orientation.Orientation_NE),
                      child: Container(
                        color: EaselAppTheme.kLightRed,
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
                          _title(
                            nft: viewModel.nft,
                            owner: viewModel.nft.type.toNftTypeEnum() == NftType.TYPE_RECIPE ? "You" : viewModel.nft.creator,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(SVGUtils.kViewsIcon),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                viewModel.viewCount == 1 ? "${viewModel.viewCount.toString()} views" : "${viewModel.viewCount.toString()} views",
                                style: TextStyle(color: Colors.white, fontSize: 12.sp),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          if (viewModel.nft.assetType.toAssetTypeEnum() == AssetType.Audio) ...[
                            Container(
                              width: 250.w,
                              color: EaselAppTheme.kWhite.withOpacity(0.2),
                              child: OwnerAudioWidget(url: viewModel.nft.url),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                          ],
                          if (viewModel.nft.assetType.toAssetTypeEnum() == AssetType.Video) ...[
                            Container(
                              width: 250.w,
                              color: EaselAppTheme.kWhite.withOpacity(0.2),
                              child: const VideoProgressWidget(
                                darkMode: true,
                                isForFile: false,
                              ),
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
                                      color: EaselAppTheme.kHashtagColor,
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
                            trimExpandedText: "collapse",
                            trimCollapsedText: "read_more",
                            moreStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: EaselAppTheme.kHashtagColor),
                            lessStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: EaselAppTheme.kHashtagColor),
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
                                        name: "ownership",
                                        icon: 'trophy',
                                        nft: viewModel.nft,
                                        owner: viewModel.owner,
                                        nftOwnershipHistoryList: const [],
                                        isExpanded: viewModel.isOwnershipExpanded,
                                        onChangeTab: viewModel.onChangeTab,
                                      ),
                                      SizedBox(height: 10.h),
                                      TabField(
                                        name: "nft_details",
                                        icon: 'detail',
                                        nft: viewModel.nft,
                                        owner: viewModel.owner,
                                        nftOwnershipHistoryList: const [],
                                        isExpanded: viewModel.isDetailsExpanded,
                                        onChangeTab: viewModel.onChangeTab,
                                      ),
                                      SizedBox(height: 10.h),
                                      if (viewModel.nft.type.toNftTypeEnum() != NftType.TYPE_RECIPE)
                                        TabField(
                                          name: "history",
                                          icon: 'history',
                                          nft: viewModel.nft,
                                          owner: viewModel.nft.owner,
                                          nftOwnershipHistoryList: viewModel.nftOwnershipHistoryList,
                                          isExpanded: viewModel.isHistoryExpanded,
                                          onChangeTab: viewModel.onChangeTab,
                                        ),
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
                                        height: 12.h,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // showDialog(
                                          //   context: context,
                                          //   builder: (_) => QRCodeScreen(
                                          //     nft: viewModel.nft,
                                          //   ),
                                          // );
                                        },
                                        child: SvgPicture.asset(
                                          SVGUtils.kQrIcon,
                                          height: 20.h,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12.h,
                                      ),
                                      if (viewModel.nft.assetType.toAssetTypeEnum() == AssetType.Image && Platform.isAndroid)
                                        GestureDetector(
                                          onTap: () {
                                            // final WallpaperScreen wallpaperScreen = WallpaperScreen(nft: viewModel.nft.url, context: context);
                                            // wallpaperScreen.show();
                                          },
                                          child: SvgPicture.asset(
                                            SVGUtils.kCreationIcon,
                                            height: 20.h,
                                            color: Colors.white,
                                          ),
                                        ),
                                      SizedBox(height: 12.h),
                                      GestureDetector(
                                        // key: const Key(kShareNftButtonExpandedKey),
                                        onTap: () async {
                                          final Size size = MediaQuery.of(context).size;
                                          // viewModel.shareNFTLink(size: size);
                                        },
                                        child: SvgPicture.asset(
                                          SVGUtils.kShareIcon,
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
                                  if (viewModel.nft.type.toNftTypeEnum() != NftType.TYPE_ITEM)
                                    Text(
                                      "${ibcEnumCoins.toIBCCoinsEnum().getCoinWithProperDenomination(viewModel.nft.price)} ${ibcEnumCoins.toIBCCoinsEnum().getAbbrev()}",
                                      style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold),
                                    )
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
          if (nft.type.toNftTypeEnum() == NftType.TYPE_RECIPE)
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
              text: "created_by",
              style: TextStyle(color: Colors.white, fontSize: 18.sp),
            ),
            TextSpan(text: owner, style: TextStyle(color: EaselAppTheme.kHashtagColor, fontSize: 18.sp)),
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: SvgPicture.asset(
                  SVGUtils.kVerifiedIcon,
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

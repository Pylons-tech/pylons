import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/screens/clippers/right_triangle_clipper.dart' as clipper;
import 'package:easel_flutter/screens/clippers/right_triangle_clipper.dart';
import 'package:easel_flutter/screens/creator_hub/creator_hub_view_model.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/progress_bar_builder.dart';
import 'package:easel_flutter/utils/read_more.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/viewmodels/home_viewmodel.dart';
import 'package:easel_flutter/widgets/audio_widget.dart';
import 'package:easel_flutter/widgets/cid_or_ipfs.dart';
import 'package:easel_flutter/widgets/clipped_button.dart';
import 'package:easel_flutter/widgets/image_widget.dart';
import 'package:easel_flutter/widgets/model_viewer.dart';
import 'package:easel_flutter/widgets/pdf_viewer.dart';
import 'package:easel_flutter/widgets/publish_button.dart';
import 'package:easel_flutter/widgets/video_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../widgets/video_progress_widget.dart';

TextStyle _rowTitleTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: isTablet ? 11.sp : 13.sp);

class PublishScreen extends StatefulWidget {
  const PublishScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  var repository = GetIt.I.get<Repository>();
  var easelProvider = GetIt.I.get<EaselProvider>();
  var homeViewModel = GetIt.I.get<HomeViewModel>();

  @override
  initState() {
    easelProvider.nft = repository.getCacheDynamicType(key: nftKey);
    easelProvider.collapsed = false;
    easelProvider.setLog(screenName: AnalyticsScreenEvents.publishScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EaselAppTheme.kBlack,
      body: Consumer<EaselProvider>(builder: (_, easelProvider, __) {
        return Stack(
          children: [
            Positioned(left: 0, right: 0, top: 0, bottom: 0, child: SizedBox(width: double.infinity, child: buildPreviewWidget(easelProvider))),
            Positioned(
                left: 10.w,
                top: 30.h,
                child: IconButton(
                  onPressed: () {
                    easelProvider.videoLoadingError = '';
                    easelProvider.isVideoLoading = true;
                    homeViewModel.previousPage();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: EaselAppTheme.kWhite,
                  ),
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: OwnerBottomDrawer(nft: easelProvider.nft),
            ),
          ],
        );
      }),
    );
  }

  Widget buildPreviewWidget(EaselProvider provider) {
    switch (provider.nft.assetType) {
      case kImageText:
        return ImageWidget(filePath: provider.nft.url.changeDomain());
      case kVideoText:
        return Center(
          child: VideoWidget(
            key: ValueKey(provider.nft.url.changeDomain()),
            filePath: provider.nft.url.changeDomain(),
            previewFlag: true,
            isForFile: false,
            isDarkMode: true,
          ),
        );
      case k3dText:
        return SizedBox(
            height: double.infinity,
            width: 1.sw,
            child: Model3dViewer(
              path: provider.nft.url.changeDomain(),
              isFile: false,
            ));
      case kAudioText:
        return AudioWidget(filePath: provider.nft.url.changeDomain(), previewFlag: false);
      case kPdfText:
        return PdfViewer(
          fileUrl: provider.nft.url,
          previewFlag: false,
        );
    }
    return const SizedBox.shrink();
  }
}

class OwnerBottomDrawer extends StatefulWidget {
  final NFT nft;

  const OwnerBottomDrawer({Key? key, required this.nft}) : super(key: key);

  @override
  State<OwnerBottomDrawer> createState() => _OwnerBottomDrawerState();
}

class _OwnerBottomDrawerState extends State<OwnerBottomDrawer> {
  bool liked = false;
  String owner = '';

  @override
  void initState() {
    super.initState();
  }

  String getCurrency() {
    final viewModel = context.read<EaselProvider>();

    if (viewModel.supportedDenomList.isEmpty) {
      return viewModel.selectedDenom.name;
    }

    return viewModel.supportedDenomList.firstWhere((denom) => denom.symbol == widget.nft.denom).name;
  }

  String getPriceSubtitle() {
    return widget.nft.isFreeDrop == FreeDrop.yes.name
        ? "0"
        : widget.nft.denom == kUsdSymbol
            ? "\$${widget.nft.price}"
            : widget.nft.price;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EaselProvider>();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildPublishBottomSheet(
            collapseStatus: viewModel.collapsed,
            onCollapsed: (context) => Container(
              decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [EaselAppTheme.kTransparent, EaselAppTheme.kBlack])),
              child: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h, bottom: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 60.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: _title(
                              nft: widget.nft,
                              owner: widget.nft.type == NftType.TYPE_RECIPE.name ? "you".tr() : widget.nft.creator,
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
                    SizedBox(height: 20.h),
                    ProgressBarBuilder(
                      audioProgressBar: (context) {
                        return SizedBox(
                            width: 330.0.w,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10.w, 10.h),
                                  child: ValueListenableBuilder<ButtonState>(
                                    valueListenable: viewModel.buttonNotifier,
                                    builder: (_, value, __) {
                                      switch (value) {
                                        case ButtonState.loading:
                                          return SizedBox(height: 20.h, width: 15.h, child: CircularProgressIndicator(strokeWidth: 2.w, color: EaselAppTheme.kWhite));
                                        case ButtonState.paused:
                                          return InkWell(
                                            onTap: () {
                                              viewModel.playAudio(false);
                                            },
                                            child: Icon(
                                              Icons.play_arrow_outlined,
                                              color: EaselAppTheme.kWhite,
                                              size: 30.h,
                                            ),
                                          );

                                        case ButtonState.playing:
                                          return InkWell(
                                            onTap: () {
                                              viewModel.pauseAudio(false);
                                            },
                                            child: Icon(
                                              Icons.pause,
                                              color: EaselAppTheme.kWhite,
                                              size: 30.h,
                                            ),
                                          );
                                      }
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: ValueListenableBuilder<ProgressBarState>(
                                    valueListenable: viewModel.audioProgressNotifier,
                                    builder: (_, value, __) {
                                      return Padding(
                                        padding: EdgeInsets.only(right: 10.w, bottom: 3.h, top: 0, left: 5.w),
                                        child: ProgressBar(
                                          progressBarColor: EaselAppTheme.kWhite,
                                          thumbColor: EaselAppTheme.kWhite,
                                          progress: value.current,
                                          baseBarColor: EaselAppTheme.kDarkGrey02,
                                          bufferedBarColor: EaselAppTheme.kLightGrey,
                                          buffered: value.buffered,
                                          total: value.total,
                                          timeLabelTextStyle: TextStyle(color: EaselAppTheme.kWhite, fontWeight: FontWeight.w800, fontSize: 9.sp),
                                          thumbRadius: 10.h,
                                          timeLabelPadding: 3.h,
                                          onSeek: (position) {
                                            viewModel.seekAudio(position, false);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ));
                      },
                      videoProgressBar: (context) {
                        return const VideoProgressWidget(darkMode: true, isForFile: false);
                      },
                      assetType: viewModel.nft.assetType,
                      others: (BuildContext context) => const SizedBox(),
                    )
                  ],
                ),
              ),
            ),
            onOpened: (context) => Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black54,
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title(nft: widget.nft, owner: widget.nft.type == NftType.TYPE_RECIPE.name ? "you".tr() : widget.nft.creator),
                      SizedBox(
                        height: 30.h,
                      ),
                      if (widget.nft.hashtags.isNotEmpty) ...[
                        Wrap(
                            spacing: 10.w,
                            children: List.generate(
                                viewModel.hashtagsList.length,
                                (index) => SizedBox(
                                      child: DetectableText(
                                        text: "#${viewModel.hashtagsList[index]}",
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
                                    ))),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                      ReadMoreText(
                        widget.nft.description,
                        trimExpandedText: "collapse".tr(),
                        trimCollapsedText: "read_more".tr(),
                        moreStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300, color: EaselAppTheme.kLightPurple),
                        lessStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w300, color: EaselAppTheme.kLightPurple),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      getProgressBarBuilder(viewModel),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            buildRow(
                              title: "currency".tr(),
                              subtitle: widget.nft.isFreeDrop == FreeDrop.yes.name ? kPylonText : getCurrency(),
                            ),
                            SizedBox(height: 5.h),
                            buildRow(title: "price".tr(), subtitle: getPriceSubtitle()),
                            SizedBox(height: 5.h),
                            buildRow(
                              title: "editions".tr(),
                              subtitle: widget.nft.quantity.toString(),
                            ),
                            SizedBox(height: 5.h),
                            buildRow(
                              title: "royalty".tr(),
                              subtitle: "${widget.nft.tradePercentage}%",
                            ),
                            SizedBox(height: 5.h),
                            buildRow(title: "content_identifier".tr(), subtitle: widget.nft.cid, canCopy: true),
                            SizedBox(height: 5.h),
                            CidOrIpfs(
                              viewCid: (context) {
                                return const SizedBox.shrink();
                              },
                              viewIpfs: (context) {
                                return buildRow(title: "asset_uri".tr(), subtitle: "view".tr(), viewIPFS: true);
                              },
                              type: widget.nft.assetType,
                            ),
                            SizedBox(height: 40.h),
                            PublishButton(
                              onPress: () async {
                                final navigator = Navigator.of(context);
                                if (viewModel.nft.assetType == kAudioText) {
                                  viewModel.disposeAudioController();
                                }
                                bool isRecipeCreated = await viewModel.verifyPylonsAndMint(nft: viewModel.nft);
                                if (!isRecipeCreated) {
                                  return;
                                }
                                GetIt.I.get<CreatorHubViewModel>().changeSelectedCollection(CollectionType.published);
                                navigator.popUntil((route) {
                                  return route.settings.name == RouteUtil.kRouteCreatorHub;
                                });
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            ClippedButton(
                              key: const Key(kSaveAsDraftPublishKey),
                              title: "save_as_draft".tr(),
                              bgColor: Colors.white.withOpacity(0.2),
                              textColor: EaselAppTheme.kWhite,
                              onPressed: () async {
                                GetIt.I.get<CreatorHubViewModel>().changeSelectedCollection(CollectionType.draft);
                                Navigator.of(context).popUntil(ModalRoute.withName(RouteUtil.kRouteCreatorHub));
                              },
                              cuttingHeight: 15.h,
                              clipperType: ClipperType.bottomLeftTopRight,
                              isShadow: false,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: ClipPath(
                    clipper: RightTriangleClipper(orientation: clipper.Orientation.orientationSW),
                    child: Container(
                      color: EaselAppTheme.kLightRed,
                      height: 50.h,
                      width: 50.h,
                      child: IconButton(
                        alignment: Alignment.topRight,
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                        onPressed: () {
                          viewModel.toChangeCollapse();
                        },
                        iconSize: 32.h,
                        color: EaselAppTheme.kWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 25.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w500),
              ),
              TextSpan(text: owner, style: TextStyle(color: EaselAppTheme.kLightPurple, fontSize: 18.sp, fontWeight: FontWeight.w500)),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SvgPicture.asset(
                    kOwnerVerifiedIcon,
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

  Widget getProgressBarBuilder(EaselProvider viewModel) {
    return ProgressBarBuilder(
      audioProgressBar: (context) {
        return Container(
          width: 250.w,
          margin: EdgeInsets.only(bottom: 30.h),
          color: EaselAppTheme.kWhite.withOpacity(0.2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10.w, bottom: 10.h, top: 10.h, left: 5.w),
                child: ValueListenableBuilder<ButtonState>(
                  valueListenable: viewModel.buttonNotifier,
                  builder: (_, value, __) {
                    switch (value) {
                      case ButtonState.loading:
                        return SizedBox(height: 22.h, width: 22.h, child: CircularProgressIndicator(strokeWidth: 2.w, color: EaselAppTheme.kWhite));
                      case ButtonState.paused:
                        return InkWell(
                          onTap: () {
                            viewModel.playAudio(false);
                          },
                          child: Icon(
                            Icons.play_arrow_outlined,
                            color: EaselAppTheme.kWhite,
                            size: 30.h,
                          ),
                        );

                      case ButtonState.playing:
                        return InkWell(
                          onTap: () {
                            viewModel.pauseAudio(false);
                          },
                          child: Icon(
                            Icons.pause,
                            color: EaselAppTheme.kWhite,
                            size: 30.h,
                          ),
                        );
                    }
                  },
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<ProgressBarState>(
                  valueListenable: viewModel.audioProgressNotifier,
                  builder: (_, value, __) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 5.h, right: 20.w),
                      child: ProgressBar(
                        progressBarColor: EaselAppTheme.kWhite,
                        thumbColor: EaselAppTheme.kWhite,
                        progress: value.current,
                        baseBarColor: EaselAppTheme.kDarkGrey02,
                        bufferedBarColor: EaselAppTheme.kLightGrey,
                        buffered: value.buffered,
                        total: value.total,
                        timeLabelTextStyle: TextStyle(color: EaselAppTheme.kWhite, fontWeight: FontWeight.w800, fontSize: 9.sp),
                        thumbRadius: 6.h,
                        timeLabelPadding: 2.h,
                        onSeek: (position) {
                          viewModel.seekAudio(position, false);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      videoProgressBar: (context) {
        if (viewModel.videoLoadingError.isNotEmpty) {
          return const SizedBox();
        }
        return Container(
          width: 250.w,
          margin: EdgeInsets.only(bottom: 30.h),
          color: EaselAppTheme.kWhite.withOpacity(0.2),
          child: const VideoProgressWidget(darkMode: true, isForFile: false),
        );
      },
      assetType: viewModel.nft.assetType,
      others: (BuildContext context) => const SizedBox(),
    );
  }

  void onViewOnIPFSPressed({required EaselProvider provider}) async {
    await provider.repository.launchMyUrl(url: provider.nft.url.changeDomain());
  }

  Widget buildRow({required String title, required String subtitle, final viewIPFS = false, final bool canCopy = false}) {
    final viewModel = context.watch<EaselProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: _rowTitleTextStyle.copyWith(fontWeight: FontWeight.w500),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                if (viewIPFS) {
                  return onViewOnIPFSPressed(provider: viewModel);
                }
              },
              child: Text(
                subtitle.trimString(kTwelve),
                style: viewIPFS ? _rowTitleTextStyle.copyWith(color: EaselAppTheme.kLightPurple) : _rowTitleTextStyle,
              ),
            ),
            if (canCopy) ...[
              SizedBox(
                width: 2.w,
              ),
              InkWell(
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: subtitle));
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("copied_to_clipboard".tr())),
                  );
                },
                child: Icon(
                  Icons.copy,
                  size: 12.h,
                  color: EaselAppTheme.kWhite,
                ),
              )
            ]
          ],
        )
      ],
    );
  }
}

class BuildPublishBottomSheet extends StatelessWidget {
  final WidgetBuilder onCollapsed;
  final WidgetBuilder onOpened;
  final bool collapseStatus;

  const BuildPublishBottomSheet({Key? key, required this.onCollapsed, required this.onOpened, required this.collapseStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (collapseStatus) {
      case true:
        return onCollapsed(context);
      case false:
        return onOpened(context);
    }
    return const SizedBox();
  }
}

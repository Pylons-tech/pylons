import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/screens/clippers/right_triangle_clipper.dart' as clipper;
import 'package:easel_flutter/screens/clippers/right_triangle_clipper.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/widgets/cid_or_ipfs.dart';
import 'package:easel_flutter/widgets/clipped_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

TextStyle _rowTitleTextStyle(Color color) => TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: isTablet ? 11.sp : 10.sp);

enum LoadingStatus { loading, success, error }

class DraftDetailDialog {
  final BuildContext context;
  final VoidCallback onClose;
  final EaselProvider easelProvider;

  DraftDetailDialog({required this.context, required this.onClose, required this.easelProvider});

  Future<void> show() async {
    if (dialogAlreadyShown(easelProvider)) return;
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => _DraftDetailDialog(
        onClose: onClose,
      ),
    );
  }

  dialogAlreadyShown(EaselProvider provider) => provider.nft.isDialogShown;
}

class _DraftDetailDialog extends StatefulWidget {
  final VoidCallback onClose;

  const _DraftDetailDialog({Key? key, required this.onClose}) : super(key: key);

  @override
  State<_DraftDetailDialog> createState() => _DraftDetailDialogState();
}

class _DraftDetailDialogState extends State<_DraftDetailDialog> {
  Widget previewWidget = const SizedBox();

  ValueNotifier<LoadingStatus> statusNotifier = ValueNotifier(LoadingStatus.loading);

  @override
  void initState() {
    super.initState();
    selectPreviewWidgetBasedOnType();
  }

  void selectPreviewWidgetBasedOnType() {
    EaselProvider easelProvider = context.read<EaselProvider>();
    if (easelProvider.nft.assetType == k3dText) {
      previewWidget = ModelViewer(
        src: easelProvider.nft.url.changeDomain(),
        ar: false,
        autoRotate: false,
        cameraControls: false,
      );

      scheduleMicrotask(() {
        statusNotifier.value = LoadingStatus.success;
      });
      return;
    }



    previewWidget = CachedNetworkImage(
      fit: BoxFit.contain,
      imageUrl: getImageUrl(easelProvider),
      imageBuilder: (context, imageProvider) {
        scheduleMicrotask(() {
          statusNotifier.value = LoadingStatus.success;
        });

        return Image(
          image: imageProvider,
        );
      },
      errorWidget: (a, b, c) {
        scheduleMicrotask(() {
          statusNotifier.value = LoadingStatus.error;
        });

        return const Center(
          child: Icon(
            Icons.error_outline,
            color: Colors.white,
          ),
        );
      },
      progressIndicatorBuilder: (context, _, DownloadProgress loadingStatus) {
        return Shimmer(
          color: EaselAppTheme.cardBackground,
          child: SizedBox(
            height: 70.h,
            width: 80.h,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    EaselProvider easelProvider = context.watch<EaselProvider>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: isTablet ? 65.w : 21.w),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          height: isTablet ? 420.h : 360.h,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: 60.h,
                  width: 60.h,
                  child: ClipPath(
                    clipper: RightTriangleClipper(orientation: clipper.Orientation.orientationNW),
                    child: Container(
                      color: EaselAppTheme.kLightRed,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: SizedBox(
                  height: 60.h,
                  width: 60.h,
                  child: ClipPath(
                    clipper: RightTriangleClipper(orientation: clipper.Orientation.orientationSE),
                    child: Container(
                      color: EaselAppTheme.kLightRed,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ipfs_upload".tr(),
                      style: TextStyle(
                        color: EaselAppTheme.kWhite,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    SizedBox(
                      height: 70.h,
                      width: 80.h,
                      child: previewWidget,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    buildRow(
                      title: "path_address".tr(),
                      subtitle: easelProvider.nft.fileName,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    ValueListenableBuilder<LoadingStatus>(
                        valueListenable: statusNotifier,
                        builder: (context, value, child) {
                          return buildRow(
                            title: "status".tr(),
                            subtitle: "status_value".tr(args: [getStatus(loadingStatus: value)]),
                            color: getColor(loadingStatus: value),
                          );
                        }),
                    SizedBox(
                      height: 5.h,
                    ),
                    CidOrIpfs(
                      viewCid: (context) {
                        return buildRow(
                          title: "content_id".tr(),
                          subtitle: easelProvider.nft.cid,
                          canCopy: true,
                        );
                      },
                      viewIpfs: (context) {
                        return buildViewOnIPFS(
                            title: "asset_uri".tr(),
                            subtitle: "view".tr(),
                            onPressed: () {
                              onViewOnIPFSPressed(provider: easelProvider);
                            });
                      },
                      type: easelProvider.nft.assetType,
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    SizedBox(
                      height: 45.h,
                      width: isTablet ? 120.w : 250.w,
                      child: ClippedButton(
                        title: "close".tr(),
                        bgColor: EaselAppTheme.kGrey.withOpacity(0.8),
                        textColor: EaselAppTheme.kWhite,
                        onPressed: () async {
                          Navigator.popUntil(context, ModalRoute.withName(RouteUtil.kRouteHome));
                          widget.onClose();
                        },
                        cuttingHeight: 15.h,
                        clipperType: ClipperType.bottomLeftTopRight,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Color getColor({required LoadingStatus loadingStatus}) {
    if (loadingStatus == LoadingStatus.success) {
      return EaselAppTheme.kDarkGreen;
    }

    if (loadingStatus == LoadingStatus.loading) {
      return EaselAppTheme.kLightYellow;
    }
    return EaselAppTheme.kRed;
  }

  String getStatus({required LoadingStatus loadingStatus}) {
    if (loadingStatus == LoadingStatus.success) {
      return "success".tr();
    }
    if (loadingStatus == LoadingStatus.loading) {
      return "in_progress".tr();
    }
    return "failed".tr();
  }

  void onViewOnIPFSPressed({required EaselProvider provider}) async {
    await provider.repository.launchMyUrl(url: provider.nft.url.changeDomain());
  }

  String getImageUrl(EaselProvider easelProvider) {
    if (easelProvider.nft.assetType == kImageText) {
      return easelProvider.nft.url.changeDomain();
    } else {
      return easelProvider.nft.thumbnailUrl.changeDomain();
    }
  }

  Widget buildViewOnIPFS({required String title, required String subtitle, required Function onPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 20.w : 40.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: EaselAppTheme.kWhite, fontWeight: FontWeight.w700, fontSize: isTablet ? 11.sp : 10.sp),
          ),
          InkWell(
            onTap: () {
              onPressed();
            },
            child: Text(
              subtitle,
              style: _rowTitleTextStyle(EaselAppTheme.kLightPurple),
            ),
          )
        ],
      ),
    );
  }

  Widget buildRow({required String title, required String subtitle, final color = Colors.white, final bool canCopy = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 20.w : 40.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: EaselAppTheme.kWhite, fontWeight: FontWeight.w700, fontSize: isTablet ? 11.sp : 10.sp),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                subtitle.trimString(kTwelve),
                style: _rowTitleTextStyle(color),
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
      ),
    );
  }
}

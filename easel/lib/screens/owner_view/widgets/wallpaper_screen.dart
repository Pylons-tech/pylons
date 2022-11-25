import 'package:easel_flutter/screens/owner_view/widgets/custom_paint_button.dart';
import 'package:easel_flutter/screens/preview_nft/nft_image_screen.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpaper/wallpaper.dart';

class WallpaperScreen {
  const WallpaperScreen({required this.nft, required this.context});

  final String nft;
  final BuildContext context;

  Future<void> show() async {
    await showGeneralDialog<String>(
      context: context,
      pageBuilder: (BuildContext context, _, __) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: _WallpaperScreen(nft: nft),
      ),
    );
  }

  _WallpaperScreen test() {
    return _WallpaperScreen(nft: nft);
  }
}

class _WallpaperScreen extends StatefulWidget {
  const _WallpaperScreen({Key? key, required this.nft}) : super(key: key);
  final String nft;

  @override
  State<_WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<_WallpaperScreen> {
  ValueNotifier<bool> downloading = ValueNotifier<bool>(false);
  ValueNotifier<bool> done = ValueNotifier<bool>(false);

  Future<void> downloadAndSetImage(BuildContext context) async {
    final Stream<String> progressString = Wallpaper.imageDownloadProgress(widget.nft);
    progressString.listen((data) {
      downloading.value = true;
    }, onDone: () async {
      downloading.value = false;
      await Wallpaper.lockScreen(options: RequestSizeOptions.RESIZE_FIT);
      done.value = true;
    }, onError: (error) {
      downloading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: EaselAppTheme.kBlack,
      child: Stack(
        children: [
          NftImageWidget(
            imageUrl: widget.nft,
          ),
          Padding(
            padding: EdgeInsets.only(left: 23.w, top: MediaQuery.of(context).viewPadding.top + 13.h),
            child: GestureDetector(
              onTap: () async {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                SVGUtils.kBackIcon,
                height: 25.h,
              ),
            ),
          ),
          Align(
            child: SizedBox(
              height: 100.h,
              width: 100.w,
              child: ValueListenableBuilder(
                valueListenable: downloading,
                builder: (BuildContext context, bool downloadingState, _) {
                  return CircularProgressIndicator(
                    value: downloadingState ? null : 0,
                    strokeWidth: 6.r,
                    color: EaselAppTheme.kWhite,
                  );
                },
              ),
            ),
          ),
          Align(
            child: SizedBox(
              height: 100.h,
              width: 100.w,
              child: ValueListenableBuilder(
                valueListenable: done,
                builder: (BuildContext context, bool doneState, _) {
                  if (doneState) {
                    return SvgPicture.asset(
                      SVGUtils.kTransactionSuccessIcon,
                      height: 100.h,
                      width: 100.w,
                      fit: BoxFit.fill,
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: ValueListenableBuilder(
                valueListenable: done,
                builder: (BuildContext context, bool doneState, _) {
                  if (!doneState) {
                    return CustomPaintButton(
                      title: "set_lockscreen".tr(),
                      bgColor: EaselAppTheme.kDartGrey,
                      width: 280.w,
                      onPressed: () async {
                        return downloadAndSetImage(context);
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

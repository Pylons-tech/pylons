import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/nft_image_asset.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/svg_util.dart';
import 'package:wallpaper/wallpaper.dart';

import '../../../generated/locale_keys.g.dart';

class WallpaperScreen {
  const WallpaperScreen({required this.nft, required this.context});
  final String nft;
  final BuildContext context;

  Future<void> show() async {
    await showGeneralDialog<String>(
        context: context,
        pageBuilder: (BuildContext context, _, __) =>
            Dialog(backgroundColor: Colors.transparent, insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0), child: _WallpaperScreen(nft: nft)));
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

  void downloadAndSetImage(BuildContext context) {
    final Stream<String> progressString = Wallpaper.imageDownloadProgress(widget.nft);
    progressString.listen((data) {
      downloading.value = true;
    }, onDone: () {
      downloading.value = false;
      Wallpaper.lockScreen(options: RequestSizeOptions.RESIZE_FIT);
      done.value = true;
    }, onError: (error) {
      downloading.value = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.kBlack,
      child: Stack(
        children: [
          NftImageWidget(
            url: widget.nft,
            opacity: 0.5,
          ),
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
                    color: AppColors.kWhite,
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
                      SVGUtil.TRANSACTION_SUCCESS,
                      height: 100.h,
                      width: 100.w,
                      fit: BoxFit.fill,
                    );
                  }
                  else {
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
                      title: LocaleKeys.set_lockscreen.tr(),
                      bgColor: AppColors.kDarkGrey,
                      width: 280.w,
                      onPressed: () async {
                        return downloadAndSetImage(context);
                      },
                    );
                  }
                  else {
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pylons_wallet/components/buttons/custom_paint_button.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/nft_image_asset.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/svg_util.dart';
import 'package:wallpaper/wallpaper.dart';


class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({Key? key, required this.nft}) : super(key: key);
  final String nft;



  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  bool downloading = false;

  @override
  void initState() {
    super.initState();

  }


  Future<void> downloadAndSetImage(BuildContext context) async {
    final Stream<String> progressString = Wallpaper.imageDownloadProgress(widget.nft);
    progressString.listen((data) {
      setState(() {
        downloading = true;
      });
    }, onDone: () async {
      setState(() {
        downloading = false;
      });
      Wallpaper.lockScreen();
      Navigator.pop(context);
    }, onError: (error) {
      setState(() {
        downloading = false;
      });
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
          width: 100.h,
          child: CircularProgressIndicator(
            value: downloading? null : 0,
            strokeWidth: 6.r,
            color: AppColors.kWhite,
          ),
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: CustomPaintButton(
                  title: "set as lockscreen",
                  bgColor: AppColors.kWhite.withOpacity(0.3),
                  width: 280.w,
                  onPressed: () async {
                    return downloadAndSetImage(context);
                  }),
            ),
          )

        ],
      ),
    );
  }

}

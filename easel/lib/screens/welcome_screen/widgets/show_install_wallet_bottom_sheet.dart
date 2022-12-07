import 'package:easel_flutter/generated/locale_keys.g.dart';
import 'package:easel_flutter/screens/clippers/top_left_bottom_right_clipper.dart';
import 'package:easel_flutter/screens/clippers/top_right_left_clipper.dart';
import 'package:easel_flutter/screens/welcome_screen/widgets/viewModel/show_install_wallet_bottom_sheet_viewmodel.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ShowInstallWalletBottomSheet {
  final BuildContext context;
  final Key key;

  ShowInstallWalletBottomSheet({required this.context, required this.key});

  void show() {
    showModalBottomSheet(
      context: context,
      backgroundColor: EaselAppTheme.kTransparent,
      builder: (context) {
        return Provider.value(
          key: key,
          value: GetIt.I.get<ShowInstallBottomSheetViewModel>(),
          builder: (context, child) {
            return const ShowInstallWalletBottomSheetContent();
          },
        );
      },
    );
  }
}

class ShowInstallWalletBottomSheetContent extends StatelessWidget {
  const ShowInstallWalletBottomSheetContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: LeftRightTopClipper(),
      child: Provider.value(
        value: GetIt.I.get<ShowInstallBottomSheetViewModel>(),
        builder: (context, child) {
          return const ShowInstallWalletBottomSheetContentChild();
        },
      ),
    );
  }
}

class ShowInstallWalletBottomSheetContentChild extends StatelessWidget {
  const ShowInstallWalletBottomSheetContentChild({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ShowInstallBottomSheetViewModel>();

    return Container(
      color: EaselAppTheme.kLightGrey02,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20.0.h,
          ),
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: EaselAppTheme.kWhite,
              borderRadius: BorderRadius.circular(
                5.r,
              ),
            ),
            padding: EdgeInsets.all(8.r),
            child: SvgPicture.asset(
              SVGUtils.kSvgPylonsLogo,
            ),
          ),
          SizedBox(
            height: 20.0.h,
          ),
          SizedBox(
            width: 0.7.sw,
            child: Text(
              LocaleKeys.you_need_to_download_pylons_app.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: EaselAppTheme.kBlack,
                fontWeight: FontWeight.bold,
                fontFamily: kUniversalFontFamily,
              ),
            ),
          ),
          SizedBox(
            height: 10.0.h,
          ),
          SizedBox(
            width: 0.75.sw,
            child: Text(
              LocaleKeys.once_you_download_the_app.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: EaselAppTheme.kBlack,
                fontWeight: FontWeight.bold,
                fontFamily: kUniversalFontFamily,
              ),
            ),
          ),
          SizedBox(
            height: 20.0.h,
          ),
          InkWell(
            onTap: () async {
              Navigator.of(context).pop();
              await viewModel.goToInstall();
            },
            child: ClipPath(
              clipper: TopLeftBottomRightClipper(),
              child: Container(
                width: 0.75.sw,
                height: 40.h,
                color: EaselAppTheme.kLightRed,
                child: Center(
                  child: Text(
                    LocaleKeys.download.tr(),
                    style: TextStyle(
                      color: EaselAppTheme.kWhite,
                      fontFamily: kUniversalFontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0.h,
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/pages/settings/screens/general_screen/general_screen.dart';
import 'package:pylons_wallet/pages/settings/screens/general_screen/general_screen_viewmodel.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

class GeneralForwardNetworkItem extends StatelessWidget {
  final String title;

  const GeneralForwardNetworkItem({
    required this.title,
    Key? key,
  }) : super(key: key);

  GeneralScreenViewModel get _generalScreenProvider => GetIt.I.get();

  @override
  Widget build(BuildContext context) {
    scheduleMicrotask(() {
      _generalScreenProvider.getSelectedValue();
    });
    return ChangeNotifierProvider<GeneralScreenViewModel>.value(
        value: _generalScreenProvider,
        builder: (context, child) {
          return Consumer<GeneralScreenViewModel>(builder: (context, viewModel, child) {
            return Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: kGeneralOptionsText,
                    ),
                    buildNetworkDropDown(viewModel),
                  ],
                ),
              ],
            );
          });
        });
  }

  Widget buildNetworkDropDown(GeneralScreenViewModel viewModel) {
    return Stack(
      children: [
        Visibility(
          visible: viewModel.dropdownVisibility,
          child: GestureDetector(
            onTap: () async {
              viewModel.changeSelectedValue();
              await viewModel.changeAppEnvConfiguration();
            },
            child: Padding(
              padding: EdgeInsets.only(top: 26.h),
              child: CustomPaint(
                painter: BoxShadowPainter(),
                child: ClipPath(
                    clipper: PylonsLongRightBottomClipper(),
                    child: Container(
                      color: AppColors.kBackgroundColor,
                      margin: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 2.h),
                      width: 140.w,
                      height: 52.h,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          SvgPicture.asset(
                            SVGUtil.DEV_NET,
                            height: 15.h,
                            color: viewModel.selectedValue == kTestNet ? AppColors.kEthereumColor : AppColors.kGreenBackground,
                          ),
                          SizedBox(width: 15.w),
                          Text(
                            viewModel.selectedValue == kTestNet ? kDevNet : kTestNet,
                            style: kDropdownText,
                          )
                        ]),
                      ),
                    )),
              ),
            ),
          ),
        ),
        CustomPaint(
          painter: BoxShadowPainter(),
          child: ClipPath(
              clipper: PylonsLongRightBottomClipper(),
              child: GestureDetector(
                onTap: () {
                  viewModel.changeDropdownVisibility();
                },
                child: Container(
                  color: AppColors.kBackgroundColor,
                  margin: EdgeInsets.only(left: 2.w, right: 2.w, bottom: 2.h),
                  width: 140.w,
                  height: 40.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    child: Row(children: [
                      SvgPicture.asset(SVGUtil.DEV_NET, height: 15.h, color: viewModel.selectedValue == kDevNet ? AppColors.kEthereumColor : AppColors.kGreenBackground),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Text(
                          viewModel.selectedValue,
                          style: kDropdownText,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: AppColors.kForwardIconColor,
                        size: 25.h,
                      ),
                    ]),
                  ),
                ),
              )),
        ),
      ],
    );
  }
}

class BoxShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width - 18.h, size.height)
      ..lineTo(size.width, size.height - 18.h)
      ..lineTo(size.width, 2);

    path.lineTo(0, 2);

    canvas.drawShadow(path, Colors.black54, 4.0, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PylonsLongRightBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width - 18.h, size.height)
      ..lineTo(size.width, size.height - 18.h)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

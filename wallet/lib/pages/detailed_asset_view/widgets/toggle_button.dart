import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view_view_model.dart';
import 'package:pylons_wallet/utils/constants.dart';

class ToggleButton extends StatefulWidget {
  const ToggleButton({Key? key}) : super(key: key);

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    final assetProvider = context.watch<OwnerViewViewModel>();
    late Color toggleColor;
    late Widget toggleChild;
    switch (assetProvider.toggled) {
      case Toggle.enabled:
        toggleColor = AppColors.kDarkGreen;
        toggleChild = enabledRow(assetProvider);
        break;
      case Toggle.disabled:
        toggleColor = AppColors.kDarkRed;
        toggleChild = disableRow(assetProvider);
        break;
      case Toggle.mid:
        toggleColor = AppColors.kAgoricColor;
        toggleChild = middleRow(assetProvider);
        break;
    }
    return Container(
        height: 35.h,
        width: 100.w,
        decoration: BoxDecoration(
          border: Border.all(
            color: toggleColor, //color of border
            width: 3.w, //width of border
          ),
        ),
        padding: EdgeInsets.all(3.r),
        child: toggleChild,
      );
  }

  Widget enabledRow(OwnerViewViewModel assetProvider) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              assetProvider.setToggle(toggle: Toggle.mid);
            },
            child: Align(
              child: Text("For sale", style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
        GestureDetector(
            onTap: () {
              assetProvider.setToggle(toggle: Toggle.mid);
            },
            child: ClipPath(
              clipper: ToggleClipperEnable(),
              child: Container(
                color: AppColors.kDarkGreen,
                height: double.infinity,
                width: 29.w,
              ),
            ),
          ),
      ],
    );
  }

  Widget middleRow(OwnerViewViewModel assetProvider) {
    return Row(
      children: [
        const Spacer(),
        Container(
          color: AppColors.kAgoricColor,
          width: 29.w,
        ),
        const Spacer(),
      ],
    );
  }

  Widget disableRow(OwnerViewViewModel assetProvider) {
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              assetProvider.setToggle(toggle: Toggle.mid);
            },
            child: ClipPath(
              clipper: ToggleClipperDisable(),
              child: Container(
                color: AppColors.kDarkRed,
                height: double.infinity,
                width: 29.w,
              ),
            ),
          ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              assetProvider.setToggle(toggle: Toggle.mid);
            },
            child: SizedBox.expand(
              child: Align(
                child: Text("Not for sale", style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ToggleClipperDisable extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width - 5.w, size.height);
    path.lineTo(size.width, size.height - 5.h);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class ToggleClipperEnable extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 5.h);
    path.lineTo(5.w, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
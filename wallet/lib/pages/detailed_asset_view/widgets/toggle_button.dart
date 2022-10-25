import 'package:flutter/material.dart';
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
    return ClipPath(
      clipper: ToggleClipper(),
      child: Container(
        height: 50,
        width: 100,
        color: assetProvider.toggled
            ? AppColors.kGreenBackground.withOpacity(.7)
            : AppColors.kDarkRed.withOpacity(.7),
        padding: const EdgeInsets.all(6.0),
        child: assetProvider.toggled
            ? enabledRow(assetProvider)
            : disableRow(assetProvider),
      ),
    );
  }

  Widget enabledRow(OwnerViewViewModel assetProvider) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              assetProvider.setToggle(toggle: false);
            },
            child: Container(
              alignment: Alignment.center,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.kButtonBuyNowColor),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              assetProvider.setToggle(toggle: false);
            },
            child: ClipPath(
              clipper: ToggleClipper(),
              child: Container(
                color: Colors.white,
                height: double.infinity,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget disableRow(OwnerViewViewModel assetProvider) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              assetProvider.setToggle(toggle: true);
            },
            child: ClipPath(
              clipper: ToggleClipper(),
              child: Container(
                color: Colors.white,
                height: double.infinity,
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              assetProvider.setToggle(toggle: true);
            },
            child: SizedBox.expand(
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.kDarkRed),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ToggleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width - 10, size.height);
    path.lineTo(size.width, size.height - 10);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../generated/locale_keys.g.dart';

class PriceWidget extends StatelessWidget {
  final String price;
  final String priceAbbr;
  final String amount;

  const PriceWidget({Key? key, required this.price, required this.priceAbbr, required this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: PriceClipper(),
      child: Container(
        color: AppColors.kGray.withOpacity(0.5),
        height: 35.h,
        width: 100.w,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$price $priceAbbr ',
                    style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    LocaleKeys.ea.tr(),
                    style: TextStyle(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.w300),
                  )
                ],
              ),
              //SizedBox(height: 1.h),
              Text(
                '$amount ${LocaleKeys.available.tr()}',
                style: TextStyle(color: AppColors.kLightGray, fontSize: 9.sp, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
    );
  }
}


class PriceClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width - 12.w, size.height);
    path.lineTo(size.width, size.height - 12.h);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

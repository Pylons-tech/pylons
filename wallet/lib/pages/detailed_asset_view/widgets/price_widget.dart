import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view_view_model.dart';
import 'package:pylons_wallet/utils/constants.dart';

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
        color: AppColors.kDarkGrey,
        height: 35.h,
        width: 110.w,
        child: ListTile(
          title: Text('$price $priceAbbr'),
          subtitle: Text(amount),
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

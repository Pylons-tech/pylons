import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/utils/constants.dart';

class CustomPaintButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Color bgColor;
  final double width;

  const CustomPaintButton({Key? key, required this.onPressed, required this.title, required this.bgColor, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed.call();
      },
      child: CustomPaint(
        painter: BoxShadowPainter(cuttingHeight: 18.h),
        child: ClipPath(
          clipper: MnemonicClipper(cuttingHeight: 18.h),
          child: Container(
            color: bgColor,
            height: 45.h,
            width: width,
            child: Center(
                child: Text(
              title,
              style: TextStyle(color: bgColor == AppColors.kButtonColor ? AppColors.kBlue : AppColors.kWhite, fontSize: 16.sp, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            )),
          ),
        ),
      ),
    );
  }
}

class MnemonicClipper extends CustomClipper<Path> {
  final double cuttingHeight;

  MnemonicClipper({required this.cuttingHeight});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - cuttingHeight);
    path.lineTo(cuttingHeight, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, cuttingHeight);
    path.lineTo(size.width - cuttingHeight, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BoxShadowPainter extends CustomPainter {
  final double cuttingHeight;

  BoxShadowPainter({required this.cuttingHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    path.lineTo(0, size.height - cuttingHeight);
    path.lineTo(cuttingHeight, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, cuttingHeight);
    path.lineTo(size.width - cuttingHeight, 0);
    path.lineTo(0, 0);

    canvas.drawShadow(path, Colors.black45, 10.0, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

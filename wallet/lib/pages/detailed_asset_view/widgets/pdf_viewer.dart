import 'dart:async';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pylons_wallet/utils/clipper_utils.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

class PdfViewer extends StatefulWidget {
  final String? fileUrl;

  const PdfViewer({Key? key, this.fileUrl}) : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  late PDFDocument doc;
  bool _isLoading = true;

  @override
  void initState() {
    initializeDoc();
    super.initState();
  }

  Future initializeDoc() async {
    doc = await PDFDocument.fromURL(widget.fileUrl!);
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: SizedBox(
          height: 50.h,
          child: Image.asset(
            ImageUtil.LOADING_GIF,
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(top: 100.h, bottom: 145.h),
      child: Center(
        child: Stack(
          children: [
            PDFViewer(
              document: doc,
              showNavigation: false,
              showPicker: false,
              progressIndicator: SizedBox(
                height: 50.0.h,
                child: Image.asset(
                  ImageUtil.LOADING_GIF,
                ),
              ),
            ),
            _buildPdfFullScreenIcon()
          ],
        ),
      ),
    );
  }

  Widget _buildPdfFullScreenIcon() {
    return Positioned(
      left: 5,
      bottom: 5,
      child: ClipPath(
        clipper: CustomTriangleClipper(),
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(RouteUtil.ROUTE_PDF_FULL_SCREEN, arguments: [doc]);
          },
          child: Container(
            width: 30.w,
            height: 30.w,
            alignment: Alignment.bottomLeft,
            color: AppColors.kTransactionRed,
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(0.25),
                child: SvgPicture.asset(
                  SVGUtil.FULL_SCREEN_ICON,
                  fit: BoxFit.fill,
                  width: 8.w,
                  height: 8.w,
                  alignment: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

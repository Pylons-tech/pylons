import 'package:easel_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PdfViewerFullOrHalf extends StatelessWidget {
  final WidgetBuilder pdfViewerFullScreen;
  final WidgetBuilder pdfViewerHalfScreen;
  final bool previewFlag;
  final bool isLoading;

  const PdfViewerFullOrHalf({Key? key, required this.pdfViewerFullScreen, required this.pdfViewerHalfScreen, required this.previewFlag, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 50.0.h,
        child: Image.asset(
          kLoadingGif,
        ),
      );
    }
    if (previewFlag) {
      return pdfViewerHalfScreen(context);
    }
    return pdfViewerFullScreen(context);
  }
}

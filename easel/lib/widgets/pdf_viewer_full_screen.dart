import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PdfViewerFullScreen extends StatefulWidget {
  const PdfViewerFullScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PdfViewerFullScreen> createState() => _PdfViewerFullScreenState();
}

class _PdfViewerFullScreenState extends State<PdfViewerFullScreen> {
  @override
  Widget build(BuildContext context) {
    final doc = ModalRoute.of(context)!.settings.arguments as List<PDFDocument>;
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: PDFViewer(
          document: doc[0],
          progressIndicator: SizedBox(
            height: 50.0.h,
            child: Image.asset(
              kLoadingGif,
            ),
          ),
        )),
      ),
    );
  }
}

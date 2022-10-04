import 'dart:async';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/image_util.dart';

class PdfViewerFullScreen extends StatefulWidget {
  const PdfViewerFullScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PdfViewerFullScreen> createState() => _PdfViewerFullScreenState();
}

class _PdfViewerFullScreenState extends State<PdfViewerFullScreen> {
  PDFDocument? pdfDocument;
  Repository get repository => GetIt.I.get();

  @override
  void initState() {
    super.initState();
    repository.logUserJourney(screenName: AnalyticsScreenEvents.pdfScreen);

    getArguments();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: (pdfDocument == null)
                ? const SizedBox()
                : PDFViewer(
                    document: pdfDocument!,
                    progressIndicator: SizedBox(
                      height: 50.0.h,
                      child: Image.asset(
                        ImageUtil.LOADING_GIF,
                      ),
                    ),
                  )),
      ),
    );
  }

  void getArguments() {
    scheduleMicrotask(() {
      if (!mounted) {
        return;
      }

      final pdfList = ModalRoute.of(context)?.settings.arguments as List<PDFDocument>?;

      if (pdfList == null) {
        return;
      }

      if (pdfList.isEmpty) {
        return;
      }

      pdfDocument = pdfList.first;

      setState(() {});
    });
  }
}

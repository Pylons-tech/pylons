import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerFullScreen extends StatefulWidget {
  const PdfViewerFullScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PdfViewerFullScreen> createState() => _PdfViewerFullScreenState();
}

class _PdfViewerFullScreenState extends State<PdfViewerFullScreen> with WidgetsBindingObserver {
  String? pdfDocument;

  Repository get repository => GetIt.I.get();

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

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
                : SfPdfViewer.network(
                  pdfDocument!,
                  //key: _pdfViewerKey,
                ),
            // PDFView(
            //         filePath: pdfDocument,
            //         swipeHorizontal: true,
            //         onRender: (_pages) {
            //           setState(() {
            //             pages = _pages;
            //             isReady = true;
            //           });
            //         },
            //         onViewCreated: (PDFViewController pdfViewController) {
            //           _controller.complete(pdfViewController);
            //         },
            //       ),
        ),
      ),
    );
  }

  void getArguments() {
    scheduleMicrotask(() {
      if (!mounted) {
        return;
      }

      final pdfList = ModalRoute.of(context)?.settings.arguments as List<String>?;

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

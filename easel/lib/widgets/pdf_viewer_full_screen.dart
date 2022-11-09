import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerFullScreen extends StatefulWidget {
  const PdfViewerFullScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PdfViewerFullScreen> createState() => _PdfViewerFullScreenState();
}

class _PdfViewerFullScreenState extends State<PdfViewerFullScreen>  with WidgetsBindingObserver {

  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
  int? pages = 0;
  bool isReady = false;

  @override
  Widget build(BuildContext context) {
    final doc = ModalRoute.of(context)!.settings.arguments as List<String>;
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: PDFView(
              filePath: doc[0],
              swipeHorizontal: true,
              onRender: (pgs) {
                setState(() {
                  pages = pgs;
                  isReady = true;
                });
              },
              onViewCreated: (PDFViewController pdfViewController) {
                _controller.complete(pdfViewController);
              },
            ),
        ),
      ),
    );
  }
}

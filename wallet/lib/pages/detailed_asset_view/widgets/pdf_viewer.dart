import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
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

class _PdfViewerState extends State<PdfViewer> with WidgetsBindingObserver {
  late String doc;
  bool _isLoading = true;

  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  void initState() {
    createFileOfPdfUrl();
    super.initState();
  }

  Future createFileOfPdfUrl() async {
    final Completer<File> completer = Completer();
    try {
      final url = widget.fileUrl!;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      final request = await HttpClient().getUrl(Uri.parse(url));
      final response = await request.close();
      final bytes = await consolidateHttpClientResponseBytes(response);
      final dir = await getApplicationDocumentsDirectory();
      final File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    final File file =  await completer.future;
    doc = file.path;
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
            PDFView(
              filePath: doc,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
              onRender: (_pages) {
                setState(() {
                  pages = _pages;
                  isReady = true;
                });
              },
              onViewCreated: (PDFViewController pdfViewController) {
                _controller.complete(pdfViewController);
              },
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

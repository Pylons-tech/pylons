import 'dart:async';
import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/screens/clippers/right_triangle_clipper.dart' as clipper;
import 'package:easel_flutter/screens/clippers/right_triangle_clipper.dart';
import 'package:easel_flutter/screens/clippers/small_bottom_corner_clipper.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/route_util.dart';
import 'package:easel_flutter/widgets/pdf_viewer_full_half_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class PdfViewer extends StatefulWidget {
  final File? file;
  final String? fileUrl;
  final bool previewFlag;

  const PdfViewer({Key? key, this.file, required this.previewFlag, this.fileUrl}) : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  EaselProvider get easelProvider => GetIt.I.get();

  late PDFDocument doc;
  bool _isLoading = true;

  String errorMsg = "";
  @override
  void initState() {
    scheduleMicrotask(() {
      easelProvider.setPdfThumbnail(null);
    });
    initializeDoc();
    super.initState();
  }

  Future initializeDoc() async {
    if (widget.file == null && widget.fileUrl == null) {
      errorMsg = "no_pdf_file".tr();
      _isLoading = false;
      setState(() {});
      return;
    }
    if (widget.file != null) {
      doc = await PDFDocument.fromFile(widget.file!);
    } else {
      doc = await PDFDocument.fromURL(widget.fileUrl!);
    }
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EaselProvider>.value(
      value: easelProvider,
      child: Center(
        child: PdfViewerFullOrHalf(
          pdfViewerFullScreen: (context) {
            return errorMsg.isNotEmpty
                ? Text(
                    errorMsg.tr(),
                    style: const TextStyle(color: EaselAppTheme.kWhite),
                  )
                : Padding(
                    padding: EdgeInsets.only(top: 100.h, bottom: 145.h),
                    child: PDFViewer(
                      document: doc,
                      showNavigation: false,
                      showPicker: false,
                      progressIndicator: SizedBox(
                        height: 50.0.h,
                        child: Image.asset(
                          kLoadingGif,
                        ),
                      ),
                    ),
                  );
          },
          pdfViewerHalfScreen: (context) {
            return SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: SizedBox(
                      height: 200.h,
                      child: errorMsg.isNotEmpty
                          ? Center(
                              child: Text(
                                errorMsg.tr(),
                              ),
                            )
                          : Stack(
                              children: [
                                PDFViewer(
                                  document: doc,
                                  showNavigation: false,
                                  showPicker: false,
                                  progressIndicator: SizedBox(
                                    height: 50.0.h,
                                    child: Image.asset(
                                      kLoadingGif,
                                    ),
                                  ),
                                ),
                                _buildPdfFullScreenIcon()
                              ],
                            )),
                ),
                SizedBox(
                  height: 50.h,
                ),
                _buildThumbnailButton(),
              ],
            ));
          },
          previewFlag: widget.previewFlag,
          isLoading: _isLoading,
        ),
      ),
    );
  }

  Widget _buildPdfFullScreenIcon() {
    return Positioned(
      left: 5,
      bottom: 0,
      child: ClipPath(
        clipper: RightTriangleClipper(orientation: clipper.Orientation.orientationNE),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteUtil.kPdfFullScreen, arguments: [doc]);
          },
          child: Container(
            width: 30.w,
            height: 30.w,
            alignment: Alignment.bottomLeft,
            color: EaselAppTheme.kLightRed,
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(0.25),
                child: SvgPicture.asset(
                  kFullScreenIcon,
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

  Widget _buildThumbnailButton() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 20.h),
        child: SizedBox(
          height: 120.h,
          width: 120.w,
          child: InkWell(
            onTap: () {
              if(errorMsg.isNotEmpty){
                'first_pick_pdf'.tr().show();
                return;
              }
              easelProvider.onPdfThumbnailPicked();
            },
            child: easelProvider.pdfThumbnail != null
                ? ClipPath(
                    clipper: RightSmallBottomClipper(),
                    child: Container(
                        height: 60.h,
                        width: 60.w,
                        margin: EdgeInsets.only(left: 10.w),
                        child: Image.file(
                          easelProvider.pdfThumbnail!,
                          height: 60.h,
                          width: 60.w,
                          fit: BoxFit.cover,
                        )),
                  )
                : SvgPicture.asset(kUploadThumbnail),
          ),
        ),
      ),
    );
  }

  bool shouldShowThumbnailButton() {
    return !widget.previewFlag;
  }
}

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/widgets/audio_widget.dart';
import 'package:easel_flutter/widgets/image_widget.dart';
import 'package:easel_flutter/widgets/model_viewer.dart';
import 'package:easel_flutter/widgets/pdf_viewer.dart';
import 'package:easel_flutter/widgets/pylons_button.dart';
import 'package:easel_flutter/widgets/video_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../generated/locale_keys.g.dart';
import '../main.dart';
import '../utils/easel_app_theme.dart';

class PreviewScreen extends StatefulWidget {
  final VoidCallback onMoveToNextScreen;

  const PreviewScreen({Key? key, required this.onMoveToNextScreen}) : super(key: key);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  Repository repository = GetIt.I.get<Repository>();

  @override
  void initState() {
    super.initState();
    repository.logUserJourney(screenName: AnalyticsScreenEvents.previewScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<EaselProvider>(
        builder: (_, provider, __) => Stack(
          children: [
            if (provider.file != null) buildPreviewWidget(provider),
            Image.asset(PngUtils.kPreviewGradient, width: 1.sw, fit: BoxFit.fill),
            if (provider.nftFormat.format == NFTTypes.image)
              SizedBox(
                key: const Key(kImageFullScreenGridviewKey),
                width: double.maxFinite,
                child: SvgPicture.asset(SVGUtils.kFullScreenImgGridview, width: 1.sw, height: 1.sh, fit: BoxFit.fill),
              ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 20.h),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: IconButton(
                      onPressed: () {
                        provider.setAudioThumbnail(null);
                        provider.setVideoThumbnail(null);
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: EaselAppTheme.kWhite,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      LocaleKeys.nft_preview_header.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: EaselAppTheme.kLightPurple,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  SizedBox(
                    width: 30.w,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 30.h,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    final result = await onUploadPressed();
                    if (result) {
                      navigator.pop();
                      widget.onMoveToNextScreen();
                    }
                  },
                  child: ClipPath(
                    clipper: PylonsButtonClipper(),
                    child: Container(
                      width: 0.75.sw,
                      height: isTablet ? 0.09.sw : 0.12.sw,
                      decoration: const BoxDecoration(color: EaselAppTheme.kBlue),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              LocaleKeys.continue_key.tr(),
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 15.sp,
                                    color: EaselAppTheme.kWhite,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPreviewWidget(EaselProvider provider) {
    switch (provider.nftFormat.format) {
      case NFTTypes.image:
        return ImageWidget(file: provider.file);
      case NFTTypes.video:
        return VideoWidget(
          file: provider.file,
          previewFlag: false,
          isForFile: true,
          isDarkMode: false,
        );
      case NFTTypes.audio:
        return AudioWidget(file: provider.file, previewFlag: true);
      case NFTTypes.threeD:
        return Model3dViewer(path: provider.file?.path, isFile: true);
      case NFTTypes.pdf:
        return PdfViewer(
          file: provider.file,
          previewFlag: true,
        );
    }
  }

  Future<bool> onUploadPressed() async {
    final provider = context.read<EaselProvider>();
    bool result = false;

    switch (provider.nftFormat.format) {
      case NFTTypes.image:
        result = await saveToUpload();
        break;
      case NFTTypes.video:
        if (provider.videoThumbnail == null) {
          context.show(message: LocaleKeys.kindly_upload_thumbnail.tr());
          return false;
        }
        result = await saveToUpload();

        break;
      case NFTTypes.audio:
        if (provider.audioThumbnail == null) {
          context.show(message: LocaleKeys.kindly_upload_thumbnail.tr());
          return false;
        }
        result = await saveToUpload();
        break;
      case NFTTypes.threeD:
        result = await saveToUpload();
        break;
      case NFTTypes.pdf:
        if (provider.pdfThumbnail == null) {
          context.show(message: LocaleKeys.kindly_upload_thumbnail.tr());
          return false;
        }
        result = await saveToUpload();
        break;
    }
    return result;
  }

  Future<bool> saveToUpload() async {
    final provider = context.read<EaselProvider>();
    if (!await provider.saveNftLocally(UploadStep.assetUploaded)) {
      LocaleKeys.something_wrong.tr().show();
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    final provider = context.read<EaselProvider>();
    provider.setAudioThumbnail(null);
    provider.setVideoThumbnail(null);
    provider.stopVideoIfPlaying();

    super.dispose();
  }
}

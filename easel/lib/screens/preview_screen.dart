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
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../utils/easel_app_theme.dart';

class PreviewScreen extends StatefulWidget {
  final VoidCallback onMoveToNextScreen;

  const PreviewScreen({Key? key, required this.onMoveToNextScreen}) : super(key: key);

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  var repository = GetIt.I.get<Repository>();
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
        builder: (_, provider, __) => WillPopScope(
          onWillPop: () {
            provider.setAudioThumbnail(null);
            provider.setVideoThumbnail(null);
            provider.stopVideoIfPlaying();

            return Future.value(true);
          },
          child: Stack(
            children: [
              if (provider.file != null) buildPreviewWidget(provider),
              Image.asset(PngUtils.kPreviewGradient, width: 1.sw, fit: BoxFit.fill),
              Column(children: [
                SizedBox(height: MediaQuery.of(context).viewPadding.top + 20.h),
                Align(
                  alignment: Alignment.center,
                  child: Text("nft_preview_header".tr(),
                      textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2!.copyWith(color: EaselAppTheme.kLightPurple, fontSize: 15.sp, fontWeight: FontWeight.w600)),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.only(left: 10.sp),
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
                      )),
                )
              ]),
              Padding(
                padding: EdgeInsets.only(bottom: 30.h, right: 25.w),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: PylonsButton(
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final result = await onUploadPressed();
                      if (result) {
                        navigator.pop();
                        widget.onMoveToNextScreen();
                      }
                    },
                    btnText: "upload".tr(),
                    showArrow: true,
                    color: EaselAppTheme.kRed,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPreviewWidget(EaselProvider provider) {
    switch (provider.nftFormat.format) {
      case NFTTypes.image:
        return ImageWidget(file: provider.file!);
      case NFTTypes.video:
        return VideoWidget(
          file: provider.file!,
          previewFlag: false,
          isForFile: true,
          isDarkMode: false,
        );
      case NFTTypes.audio:
        return AudioWidget(file: provider.file!, previewFlag: true);
      case NFTTypes.threeD:
        return Model3dViewer(path: provider.file!.path, isFile: true);
      case NFTTypes.pdf:
        return PdfViewer(
          file: provider.file!,
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
          context.show(message: "kindly_upload_thumbnail".tr());
          return false;
        }
        result = await saveToUpload();

        break;
      case NFTTypes.audio:
        if (provider.audioThumbnail == null) {
          context.show(message: "kindly_upload_thumbnail".tr());
          return false;
        }
        result = await saveToUpload();
        break;
      case NFTTypes.threeD:
        result = await saveToUpload();
        break;
      case NFTTypes.pdf:
        if (provider.pdfThumbnail == null) {
          context.show(message: "kindly_upload_thumbnail".tr());
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
      'something_wrong'.tr().show();
      return false;
    }
    return true;
  }
}

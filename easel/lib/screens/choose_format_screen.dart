import 'dart:io';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/models/picked_file_model.dart';
import 'package:easel_flutter/screens/preview_screen.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/space_utils.dart';
import 'package:easel_flutter/viewmodels/home_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../generated/locale_keys.g.dart';
import 'custom_widgets/step_labels.dart';
import 'custom_widgets/steps_indicator.dart';

class ChooseFormatScreen extends StatefulWidget {
  const ChooseFormatScreen({Key? key}) : super(key: key);

  @override
  State<ChooseFormatScreen> createState() => _ChooseFormatScreenState();
}

class _ChooseFormatScreenState extends State<ChooseFormatScreen> {
  ValueNotifier<String> errorText = ValueNotifier(LocaleKeys.err_pic_file.tr());

  Future<void> proceedToNext({required PickedFileModel result, required EaselProvider easelProvider}) async {
    final EaselProvider provider = context.read();
    final navigator = Navigator.of(context);

    if (result.path.isEmpty) {
      return;
    }

    if (!provider.nftFormat.extensions.contains(result.extension)) {
      final fileName = result.fileName.replaceAll(".${result.extension}", "");
      errorText.value = LocaleKeys.could_not_uploaded.tr(
        namedArgs: {
          kFileName: fileName,
          kFormat: provider.nftFormat.format.getTitle(),
        },
      );
      showErrorDialog(extensions: provider.nftFormat.extensions);
      return;
    }

    final NftFormat? nftFormat = await provider.resolveNftFormat(context, result.extension);

    if (nftFormat == null) {
      return;
    }

    if (easelProvider.repository.getFileSizeInGB(File(result.path).lengthSync()) > kFileSizeLimitForAudioVideoInGB) {
      errorText.value = LocaleKeys.size_error.tr();
      showErrorDialog(type: nftFormat.format, extensions: nftFormat.extensions);
      return;
    }

    await provider.setFile(fileName: result.fileName, filePath: result.path);

    navigator.push(MaterialPageRoute(
        builder: (_) => PreviewScreen(
              onMoveToNextScreen: () {
                context.read<HomeViewModel>().nextPage();
              },
            )));
  }

  void showErrorDialog({NFTTypes? type, required List<String> extensions}) {
    showDialog(
      context: context,
      builder: (context) => _ErrorMessageWidget(
        errorMessage: errorText.value,
        extensions: extensions,
        nftTypes: type,
        onClose: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final EaselProvider provider = context.read();
    provider.setLog(screenName: AnalyticsScreenEvents.chooseFormatScreen);
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();

    final EaselProvider provider = context.read();
    return Scaffold(
      body: Column(
        children: [
          const VerticalSpace(20),
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: ValueListenableBuilder(
                  valueListenable: homeViewModel.currentPage,
                  builder: (_, int currentPage, __) => Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: EaselAppTheme.kGrey,
                      ),
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: homeViewModel.currentPage,
                builder: (_, int currentPage, __) {
                  return Column(
                    key: const Key(kProgressStepsKey),
                    children: [
                      const VerticalSpace(20),
                      MyStepsIndicator(currentStep: homeViewModel.currentStep),
                      const VerticalSpace(5),
                      StepLabels(currentPage: homeViewModel.currentPage, currentStep: homeViewModel.currentStep),
                    ],
                  );
                },
              ),
            ],
          ),
          const VerticalSpace(20),
          Expanded(
            child: _CardWidget(
              typeIdx: 0,
              selected: provider.nftFormat.format == NftFormat.supportedFormats[0].format,
              onFilePicked: (result) async {
                proceedToNext(result: result, easelProvider: provider);
              },
              topPadding: 5.0.h,
              bottomPadding: 5.0.h,
            ),
          ),
          Expanded(
            child: _CardWidget(
              typeIdx: 1,
              selected: provider.nftFormat.format == NftFormat.supportedFormats[1].format,
              onFilePicked: (result) async {
                proceedToNext(result: result, easelProvider: provider);
              },
              bottomPadding: 5.0.h,
            ),
          ),
          Expanded(
            child: _CardWidget(
              typeIdx: 2,
              selected: provider.nftFormat.format == NftFormat.supportedFormats[2].format,
              onFilePicked: (result) async {
                proceedToNext(result: result, easelProvider: provider);
              },
              textIconColor: EaselAppTheme.kNightBlue,
              bottomPadding: 5.0.h,
            ),
          ),
          Expanded(
            child: _CardWidget(
              typeIdx: 3,
              selected: provider.nftFormat.format == NftFormat.supportedFormats[3].format,
              onFilePicked: (result) async {
                proceedToNext(result: result, easelProvider: provider);
              },
              bottomPadding: 5.0.h,
            ),
          ),
          Expanded(
            child: _CardWidget(
              typeIdx: 4,
              selected: provider.nftFormat.format == NftFormat.supportedFormats[4].format,
              onFilePicked: (result) async {
                proceedToNext(result: result, easelProvider: provider);
              },
              bottomPadding: 5.0.h,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardWidget extends StatelessWidget {
  const _CardWidget({
    Key? key,
    required this.typeIdx,
    this.selected = false,
    required this.onFilePicked,
    this.textIconColor = Colors.white,
    this.topPadding = 0.0,
    this.bottomPadding = 0.0,
  }) : super(key: key);

  final Function(PickedFileModel) onFilePicked;
  final int typeIdx;
  final bool selected;
  final Color textIconColor;
  final double topPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: EaselAppTheme.kBlack,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
              child: GestureDetector(
                onTap: () async {
                  final EaselProvider provider = context.read();
                  provider.setFormat(context, NftFormat.supportedFormats[typeIdx]);
                  final pickedFile = await provider.repository.pickFile(provider.nftFormat);
                  final result = pickedFile.getOrElse(() => PickedFileModel(path: "", fileName: "", extension: ""));
                  onFilePicked(result);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 0.02.sw, vertical: 4.5.h),
                  decoration: BoxDecoration(color: NftFormat.supportedFormats[typeIdx].color),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10.0.w,
                          ),
                          SvgPicture.asset(
                            NftFormat.supportedFormats[typeIdx].badge,
                          ),
                          SizedBox(
                            width: 20.0.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  NftFormat.supportedFormats[typeIdx].format.getTitle().toUpperCase(),
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        color: textIconColor,
                                        fontSize: 45.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(height: 3.h),
                                RichText(
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                          color: textIconColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    text: NftFormat.supportedFormats[typeIdx].getExtensionsList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 5.0.h),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: SizedBox(
                            child: SvgPicture.asset(
                              SVGUtils.kSvgForwardArrowIcon,
                              color: textIconColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({
    Key? key,
    required this.errorMessage,
    required this.extensions,
    required this.onClose,
    this.nftTypes,
  }) : super(key: key);

  final String errorMessage;
  final VoidCallback onClose;
  final NFTTypes? nftTypes;
  final List<String> extensions;

  @override
  Widget build(BuildContext context) {
    return buildMobile(context);
  }

  Widget buildMobile(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 0.1.sw, vertical: 0.08.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
            decoration: const BoxDecoration(color: EaselAppTheme.kRed),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  (nftTypes == NFTTypes.video || nftTypes == NFTTypes.audio)
                      ? "• ${(kFileSizeLimitForAudioVideoInGB * 1000).toStringAsFixed(0)}MB limit"
                      : "• ${kFileSizeLimitInGB}GB limit",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Text(
                  "• ${extensions.join(", ").toUpperCase()}",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Text(
                  LocaleKeys.upload_hint_three.tr(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

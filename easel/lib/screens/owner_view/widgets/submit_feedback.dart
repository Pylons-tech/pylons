import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/utils/clipper_utils.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/screen_responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easel_flutter/utils/enums.dart' as enums;
import '../../../generated/locale_keys.g.dart';

class SubmitFeedback {
  final BuildContext context;

  SubmitFeedback({
    required this.context,
  });

  Future<void> show() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? 65.w : 21.w,
        ),
        child: const _SubmitFeedbackDialogContent(),
      ),
    );
  }
}

class _SubmitFeedbackDialogContent extends StatefulWidget {
  const _SubmitFeedbackDialogContent({Key? key}) : super(key: key);

  @override
  State<_SubmitFeedbackDialogContent> createState() => _SubmitFeedbackDialogContentState();
}

class _SubmitFeedbackDialogContentState extends State<_SubmitFeedbackDialogContent> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController subjectController = TextEditingController();
  TextEditingController descController = TextEditingController();

  final ValueNotifier<String> _subjectFieldError = ValueNotifier("");
  final ValueNotifier<String> _descriptionFieldError = ValueNotifier("");

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  // Future<void> onSubmitButtonPressed() async {
  //   final account = context.read<AccountProvider>().accountPublicInfo;
  //
  //   Navigator.pop(context);
  //
  //   if (account == null) {
  //     return;
  //   }
  //   final loader = Loading()..showLoading();
  //   final repository = GetIt.I.get<Repository>();
  //   final walletAddress = account.publicAddress;
  //   final responseEither = await repository.saveUserFeedback(
  //     walletAddress: walletAddress,
  //     subject: subjectController.text,
  //     feedback: descController.text,
  //   );
  //   if (responseEither.isLeft()) {
  //     loader.dismiss();
  //     return LocaleKeys.something_wrong.tr().show();
  //   }
  //   loader.dismiss();
  //
  //   return LocaleKeys.thank_you_for_feedback.tr().show();
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: EaselAppTheme.kLightGreyColor,
        height: isTablet ? 520.h : 480.h,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: 60.h,
                width: 60.h,
                child: ClipPath(
                  clipper: RightTriangleOwnerViewClipper(
                    orientation: enums.Orientation.Orientation_NW,
                  ),
                  child: ColoredBox(color: EaselAppTheme.kTransactionRed),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: SizedBox(
                height: 60.h,
                width: 60.h,
                child: ClipPath(
                  clipper: RightTriangleOwnerViewClipper(
                    orientation: enums.Orientation.Orientation_SE,
                  ),
                  child: ColoredBox(
                    color: EaselAppTheme.kTransactionRed,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "submit_feedback",
                      style: TextStyle(
                        color: EaselAppTheme.kBlack,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FeedBackTextField(
                            label: "subject",
                            controller: subjectController,
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) {
                              if (value!.isEmpty) {
                                _subjectFieldError.value = "enter_subject_text";
                                return;
                              }
                              _subjectFieldError.value = '';
                              return null;
                            },
                          ),
                          ValueListenableBuilder<String>(
                              valueListenable: _subjectFieldError,
                              builder: (_, String subjectFieldError, __) {
                                if (subjectFieldError.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 2.h),
                                  child: Text(
                                    subjectFieldError.tr(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.red,
                                    ),
                                  ),
                                );
                              }),
                          SizedBox(
                            height: 10.h,
                          ),
                          FeedBackTextField(
                            label: "description",
                            noOfLines: 5,
                            controller: descController,
                            textCapitalization: TextCapitalization.sentences,
                            inputFormatters: [LengthLimitingTextInputFormatter(kMaxDescription)],
                            validator: (value) {
                              if (value!.isEmpty) {
                                _descriptionFieldError.value = "enter_description_text";
                                return;
                              }
                              _descriptionFieldError.value = '';
                              return null;
                            },
                          ),
                          ValueListenableBuilder<String>(
                              valueListenable: _descriptionFieldError,
                              builder: (_, String descriptionFieldError, __) {
                                if (descriptionFieldError.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 2.h),
                                  child: Text(
                                    descriptionFieldError.tr(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.red,
                                    ),
                                  ),
                                );
                              }),
                          ValueListenableBuilder(
                              valueListenable: descController,
                              builder: (_, TextEditingValue controller, __) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        LocaleKeys.character_limit.tr(
                                          args: [
                                            (kMaxDescription - controller.text.length).toString(),
                                          ],
                                        ),
                                        style: TextStyle(
                                          color: EaselAppTheme.kHashtagColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      ),
                    ),
                    CustomPaintButton(
                      title: "submit",
                      bgColor: EaselAppTheme.kBlue,
                      width: 200.w,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        if (_subjectFieldError.value.isNotEmpty || _descriptionFieldError.value.isNotEmpty) {
                          return;
                        }

                        // onSubmitButtonPressed();
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FeedbackModel {
  final String walletAddress;
  final String subject;
  final String feedback;
  final String timestamp;

  FeedbackModel({
    required this.walletAddress,
    required this.subject,
    required this.feedback,
    required this.timestamp,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> map) => FeedbackModel(
        walletAddress: map[kAddressKey] == null ? "" : (map[kAddressKey]).toString(),
        subject: map[kSubjectKey] == null ? "" : (map[kSubjectKey]).toString(),
        feedback: map[kFeedbackKey] == null ? "" : (map[kFeedbackKey]).toString(),
        timestamp: map[kTimeStampKey] == null ? "" : (map[kTimeStampKey]).toString(),
      );

  Map<String, dynamic> toMap() {
    return {
      kAddressKey: walletAddress,
      kSubjectKey: subject,
      kFeedbackKey: feedback,
      kTimeStampKey: timestamp,
    };
  }
}

class FeedBackTextField extends StatelessWidget {
  const FeedBackTextField(
      {Key? key,
      required this.label,
      this.hint = "",
      this.controller,
      this.validator,
      this.noOfLines = 1, // default to single line
      this.inputFormatters = const [],
      this.keyboardType = TextInputType.text,
      this.textCapitalization = TextCapitalization.none})
      : super(key: key);

  final String label;
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int noOfLines;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: EaselAppTheme.kBlack),
        ),
        SizedBox(height: 4.h),
        Stack(
          children: [
            ScreenResponsive(
              mobileScreen: (context) => Image.asset(
                isOneLine() ? PngUtils.kTextFieldSingleLine : PngUtils.kTextFieldMultiLine,
                height: isOneLine() ? 40.h : 120.h,
                width: 1.sw,
                fit: BoxFit.fill,
              ),
              tabletScreen: (context) => Image.asset(
                isOneLine() ? PngUtils.kTextFieldSingleLine : PngUtils.kTextFieldMultiLine,
                height: isOneLine() ? 32.h : 110.h,
                width: 1.sw,
                fit: BoxFit.fill,
              ),
            ),
            ScreenResponsive(mobileScreen: (_) => buildMobileTextField(), tabletScreen: (_) => buildTabletTextField()),
          ],
        ),
      ],
    );
  }

  bool isOneLine() => noOfLines == 1;

  SizedBox buildMobileTextField() {
    return SizedBox(
      height: isOneLine() ? 40.h : 120.h,
      child: Align(
        child: TextFormField(
          style: TextStyle(
            fontSize: isOneLine() ? 18.sp : 15.sp,
            fontWeight: FontWeight.w400,
            color: EaselAppTheme.kDarkText,
          ),
          controller: controller,
          validator: validator,
          minLines: noOfLines,
          maxLines: noOfLines,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: EaselAppTheme.kGrey,
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.fromLTRB(
              10.w,
              0.h,
              10.w,
              0.h,
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildTabletTextField() {
    return SizedBox(
      height: isOneLine() ? 32.h : 110.h,
      child: Align(
        child: TextFormField(
          style: TextStyle(
            fontSize: isOneLine() ? 16.sp : 14.sp,
            fontWeight: FontWeight.w400,
            color: EaselAppTheme.kDarkText,
          ),
          controller: controller,
          validator: validator,
          minLines: noOfLines,
          maxLines: noOfLines,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: isOneLine() ? 16.sp : 14.sp,
              color: EaselAppTheme.kGrey,
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.fromLTRB(
              10.w,
              0.h,
              10.w,
              0.h,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomPaintButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final Color bgColor;
  final double width;

  const CustomPaintButton({Key? key, required this.onPressed, required this.title, required this.bgColor, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed.call();
      },
      child: CustomPaint(
        painter: BoxShadowPainter(cuttingHeight: 18.h),
        child: ClipPath(
          clipper: MnemonicClipper(cuttingHeight: 18.h),
          child: Container(
            color: bgColor,
            height: 45.h,
            width: width,
            child: Center(
                child: Text(
              title,
              style: TextStyle(
                color: bgColor == EaselAppTheme.kWhite ? EaselAppTheme.kBlue : EaselAppTheme.kWhite,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            )),
          ),
        ),
      ),
    );
  }
}

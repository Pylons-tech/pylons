import 'dart:async';

import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/main.dart';
import 'package:easel_flutter/models/upload_progress.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/image_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/percent_indicator.dart';



class LoadingProgress {
  LoadingProgress();

  void dismiss() {
    navigatorKey.currentState?.pop();
  }
  final EaselProvider easelProvider= GetIt.I.get<EaselProvider>();

  Future showLoadingWithProgress({String? message}) {
    if (navigatorKey.currentState?.overlay == null) {
      return Completer()
          .future; // return a fake future if state is screwy - this only ever happens during testing. todo: eliminate this hack
    }
    return showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      barrierDismissible: true,
      barrierColor: Colors.white.withOpacity(0),
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content:StreamBuilder<UploadProgress>(
                stream: easelProvider.uploadProgressStream,
                builder: (context, uploadProgress) {
                  return CircularPercentIndicator(
                    radius: 60.h,
                    lineWidth: 5.w,
                    percent:uploadProgress.hasData? uploadProgress.data!.uploadedProgressData : 0,
                    center:  SizedBox(
                        height: 100.h,
                        width: 100.h,
                        child: Image.asset(ImageUtil.LOADING_GIF)),

                    progressColor: EaselAppTheme.kLightRed,

                    backgroundColor: EaselAppTheme.kLightPurple,
                  );
                }
            )
        ),
      )
    );
  }
}

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';

class SDKApprovalDialog {
  final BuildContext context;
  final SdkIpcMessage sdkipcMessage;
  final VoidCallback onApproved;
  final VoidCallback onCancel;

  SDKApprovalDialog({required this.context, required this.sdkipcMessage, required this.onApproved, required this.onCancel});

  Future show() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.transparent,
        builder: (_) {
          final screenSize = ScreenSizeUtil(_);
          return WillPopScope(
            onWillPop: () async => false,
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Align(
                  child: SizedBox(
                    width: screenSize.width(),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
                      ),
                    ),
                  ),
                ),
                Align(
                  child: Container(
                    width: screenSize.width(),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.kWhite.withOpacity(0.6),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.kBlue.withOpacity(0.4),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '"${sdkipcMessage.sender}" ${'would_like_to'.tr()} ${sdkipcMessage.action}?',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline6!.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const VerticalSpace(30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(_).pop();
                                  onCancel.call();
                                },
                                child: Text(
                                  'dont_allow'.tr(),
                                  style: TextStyle(fontSize: 16, color: AppColors.kWhite, fontWeight: FontWeight.w300),
                                ),
                              ),
                              const HorizontalSpace(30),
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.kWhite.withOpacity(0.7),
                                  side: BorderSide(color: AppColors.kWhite.withOpacity(0.5)),
                                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 6),
                                ),
                                onPressed: () async {
                                  Navigator.of(_).pop();
                                  onApproved.call();
                                },
                                child: Text(
                                  'ok'.tr(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.kWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

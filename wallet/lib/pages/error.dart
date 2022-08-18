import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void showFileSizeError(int limit, BuildContext context) {
  final displayLimit = limit / 1024 / 1024;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("filesize_err_title".tr()),
        content:
            Text('filesize_err'.tr() + displayLimit.toString() + 'mb'.tr()),
        actions: <Widget>[
          TextButton(
            child: Text("close".tr()),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

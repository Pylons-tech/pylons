import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';

void showFileSizeError(int limit, BuildContext context) {
  final displayLimit = limit / 1024 / 1024;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(LocaleKeys.filesize_err_title.tr()),
        content:
            Text(LocaleKeys.filesize_err.tr() + displayLimit.toString() + LocaleKeys.mb.tr()),
        actions: <Widget>[
          TextButton(
            child: Text(LocaleKeys.close.tr()),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/pages/error.dart';

import 'package:pylons_wallet/services/repository/repository.dart';

class UserBannerViewModel extends ChangeNotifier {
  void setToFile(int filesizeLimit, String uriKey, File? file, BuildContext context) {
    if (file == null) return;

    final bytes = file.readAsBytesSync();
    if (bytes.length > filesizeLimit) {
      if (Navigator.canPop(context)) {
        showFileSizeError(filesizeLimit, context);
      }
    } else {
      GetIt.I.get<Repository>().saveImage(
            imagePath: file.uri.toString(),
            key: uriKey,
          );
    }
    notifyListeners();
  }
}

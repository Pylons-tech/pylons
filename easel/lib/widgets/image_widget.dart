import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/dependency_injection/dependency_injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageWidget extends StatelessWidget {
  final File? file;
  final String? filePath;

  const ImageWidget({Key? key, this.file, this.filePath}) : super(key: key);

  EaselProvider get easelProvider => sl();

  Widget buildImage() {
    if (file == null) {
      return SizedBox(
        height: double.infinity,
        child: CachedNetworkImage(
          fit: BoxFit.fitHeight,
          imageUrl: filePath!,
          errorWidget: (a, b, c) => const Center(child: Icon(Icons.error_outline)),
          placeholder: (context, url) => Center(
            child: SizedBox(
              height: 50.0.h,
              child: Image.asset(
                kLoadingGif,
              ),
            ),
          ),
        ),
      );
    }

    return Image.memory(
      file!.readAsBytesSync(),
      width: 1.sw,
      height: 1.sh,
      fit: easelProvider.imageCheckBox ? BoxFit.fitHeight : BoxFit.fitWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Stack(
          children: [
            buildImage(),
          ],
        ),
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
        });
  }
}

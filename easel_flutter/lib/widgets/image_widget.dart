import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageWidget extends StatelessWidget {
  final File? file;
  final String? filePath;

  const ImageWidget({Key? key, this.file, this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return file != null
        ? Image.memory(
            file!.readAsBytesSync(),
            width: 1.sw,
            height: 1.sh,
            fit: BoxFit.fitHeight,
          )
        : SizedBox(
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
}

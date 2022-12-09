import 'dart:core';

import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:flutter/cupertino.dart';

class NftFormat {
  final NFTTypes format;
  final List<String> extensions;
  final String badge;
  final Color color;

  NftFormat({
    required this.format,
    required this.extensions,
    required this.badge,
    required this.color,
  });

  String getExtensionsList() {
    final buffer = StringBuffer();
    for (var i = 0; i < extensions.length; i++) {
      if (buffer.isNotEmpty) {
        buffer.write(", ");
      }
      buffer.write(extensions[i].toUpperCase());
    }
    return buffer.toString();
  }

  static List<NftFormat> get supportedFormats => [
        NftFormat(
          format: NFTTypes.image,
          extensions: ['jpg', 'png', 'svg', 'heif', 'jpeg', 'gif'],
          badge: SVGUtils.kSvgNftFormatImage,
          color: EaselAppTheme.kBlue,
        ),
        NftFormat(
          format: NFTTypes.video,
          extensions: ['mp4', 'mov', 'm4v', 'avi', 'hevc'],
          badge: SVGUtils.kSvgNftFormatVideo,
          color: EaselAppTheme.kDarkGreen,
        ),
        NftFormat(
          format: NFTTypes.threeD,
          extensions: ['gltf', 'glb'],
          badge: SVGUtils.kSvgNftFormat3d,
          color: EaselAppTheme.kYellow,
        ),
        NftFormat(
          format: NFTTypes.audio,
          extensions: ['wav', 'aiff', 'alac', 'flac', 'mp3', 'aac', 'wma', 'ogg'],
          badge: SVGUtils.kAudioFileIcon,
          color: EaselAppTheme.kLightRed,
        ),
        NftFormat(
          format: NFTTypes.pdf,
          extensions: ['pdf'],
          badge: SVGUtils.kSvgNftFormatPDF,
          color: EaselAppTheme.kDarkPurple,
        ),
      ];

  static List<String> getAllSupportedExts() {
    List<String> allExts = [];
    for (final format in supportedFormats) {
      allExts += format.extensions;
    }
    return allExts;
  }
}

enum NFTTypes { image, video, audio, threeD, pdf }

extension NFTTypesDetails on NFTTypes {
  String getTitle() {
    switch (this) {
      case NFTTypes.image:
        return kImageText;
      case NFTTypes.video:
        return kVideoText;
      case NFTTypes.audio:
        return kAudioText;
      case NFTTypes.threeD:
        return k3dText;
      case NFTTypes.pdf:
        return kPdfText;
    }
  }
}

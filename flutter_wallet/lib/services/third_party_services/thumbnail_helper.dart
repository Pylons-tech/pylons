import 'dart:io';
import 'package:video_thumbnail/video_thumbnail.dart';

/// Abstract Class for providing Thumbnail Generations

abstract class ThumbnailHelper {
  String ifThumbnailAlreadyExists(String nftName, String thumbnailsPath);

  Future<String?> generateVideoThumbnailIfRequired(
      String nftUrl, String nftName, String thumbnailsPath);
}

/// [ThumbnailHelperImp] implementation of [ThumbnailHelper]
class ThumbnailHelperImp implements ThumbnailHelper {
  /// This method will be checking if there is already a thumbnail generated for video
  /// If exists it will return the local path, otherwise ""
  @override
  String ifThumbnailAlreadyExists(String nftName, String thumbnailsPath) {
    final tempFile = File('$thumbnailsPath/$nftName.webp');
    if (tempFile.existsSync()) {
      return tempFile.path;
    }
    return "";
  }

  /// This method will be responsible for generating video thumbnails and storing in temp storage
  /// This will return the path for generated thumbnail
  @override
  Future<String?> generateVideoThumbnailIfRequired(
      String nftUrl, String nftName, String thumbnailsPath) async {
    final temp = ifThumbnailAlreadyExists(nftName, thumbnailsPath);

    if (temp.isNotEmpty) {
      return temp;
    }
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: nftUrl,
      thumbnailPath: thumbnailsPath,
      imageFormat: ImageFormat.WEBP,
      maxHeight: 100,
      maxWidth: 150,
      quality: 75,
    );

    final newFile =
        File(thumbnailPath!).renameSync('$thumbnailsPath/$nftName.webp');

    return newFile.path;
  }
}

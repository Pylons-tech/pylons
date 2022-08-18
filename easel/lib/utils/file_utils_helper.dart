import 'dart:io';
import 'dart:math';
import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/models/picked_file_model.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'constants.dart';

abstract class FileUtilsHelper {
  /// This function picks a file with the given format from device storage
  /// Input: [format] it is the file format which needs to be picked from local storage
  /// returns [PlatformFile] the selected file or null if aborted
  Future<PickedFileModel> pickFile(NftFormat format);

  /// This function is used to get the file size in String format
  /// Input: [fileLength] the file length in bytes and [precision]
  /// Output: [String] returns the file size in String format
  String getFileSizeString({required int fileLength, required int precision});

  /// This function is used to generate the NFT link to be shared with others after publishing
  /// Input: [recipeId] and [cookbookId] used in the link generation as query parameters
  /// Output: [String] returns the generated NFTs link to be shared with others
  String generateEaselLinkForShare(
      {required String recipeId, required String cookbookId});

  /// This function is used to generate the NFT link to be open in the pylons wallet
  /// Input: [recipeId] and [cookbookId] used in the link generation as query parameters
  /// Output: [String] returns the generated NFTs link to be shared with others
  String generateEaselLinkForOpeningInPylonsApp(
      {required String recipeId, required String cookbookId});

  /// This function is used to launch the link generated and open the link in external source platform
  /// Input: [url] is the link to be launched by the launcher
  Future<void> launchMyUrl({required String url});

  /// This function will copy the file to internal memory returns the updated path
  /// Input: [filePickerResult] is the filePickerResult instance of the file to be copied
  /// Output: [String] This will return the updated filePath
  Future<File> copyFileToInternal({required FilePickerResult filePickerResult});
}

class FileUtilsHelperImpl implements FileUtilsHelper {
  ImageCropper imageCropper;
  FilePicker filePicker;

  FileUtilsHelperImpl({required this.imageCropper, required this.filePicker});

  @override
  Future<PickedFileModel> pickFile(NftFormat format) async {
    FileType _type;
    List<String>? allowedExtensions;
    switch (format.format) {
      case NFTTypes.image:
        if (Platform.isAndroid) {
          _type = FileType.custom;
          allowedExtensions = imageAllowedExts;
          break;
        }
        _type = FileType.image;
        break;

      case NFTTypes.video:
        _type = FileType.video;
        break;

      case NFTTypes.audio:
        if (!Platform.isAndroid) {
          _type = FileType.custom;
          allowedExtensions = audioAllowedExts;
        } else {
          _type = FileType.audio;
        }
        break;
      default:
        _type = FileType.any;
        break;
    }

    FilePickerResult? result = await filePicker.pickFiles(
        type: _type, allowedExtensions: allowedExtensions);

    if (result == null) {
      return PickedFileModel(
        path: '',
        fileName: '',
        extension: '',
      );
    }

    if (format.format == NFTTypes.threeD && result.files.single.path != null) {
      final newFile = await copyFileToInternal(filePickerResult: result);
      return PickedFileModel(
        path: newFile.path,
        fileName: newFile.path.split('/').last,
        extension: result.files.single.extension ?? "",
      );
    }

    if (format.format == NFTTypes.image && result.files.single.path != null) {
      final cropperImage = await cropImage(filePath: result.files.single.path!);
      return PickedFileModel(
        path: cropperImage,
        fileName: result.files.single.name,
        extension: result.files.single.extension ?? "",
      );
    }

    return PickedFileModel(
      path: result.files.single.path ?? "",
      fileName: result.files.single.name,
      extension: result.files.single.extension ?? "",
    );
  }

  @override
  String getFileSizeString({required int fileLength, required int precision}) {
    var i = (log(fileLength) / log(1024)).floor();
    return ((fileLength / pow(1024, i)).toStringAsFixed(precision)) +
        suffixes[i];
  }

  @override
  String generateEaselLinkForShare(
      {required String recipeId, required String cookbookId}) {
    return "$kWalletWebLink/?action=purchase_nft&recipe_id=$recipeId&cookbook_id=$cookbookId";
  }

  @override
  Future<void> launchMyUrl({required String url}) async {
    final canLaunch = await canLaunchUrlString(url);
    if (canLaunch) {
      launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw ("cannot_launch_url".tr());
    }
  }

  Future<String> cropImage({required String filePath}) async {
    try {
      CroppedFile? croppedFile = await imageCropper.cropImage(
        sourcePath: filePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: kPylons,
              toolbarColor: EaselAppTheme.kBlue,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: kPylons,
          ),
        ],
      );
      return croppedFile?.path ?? "";
    } catch (e) {
      return "";
    }
  }

  @override
  String generateEaselLinkForOpeningInPylonsApp(
      {required String recipeId, required String cookbookId}) {
    return Uri.https('pylons.page.link', "/", {
      kAmvKey: "1",
      kApnKey: "tech.pylons.wallet",
      kIbiKey: "xyz.pylons.wallet",
      kImvKey: "1",
      kLinkKey:
          "https://wallet.pylons.tech/?action=purchase_nft&recipe_id=$recipeId&cookbook_id=$cookbookId&nft_amount=1"
    }).toString();
  }

  @override
  Future<File> copyFileToInternal(
      {required FilePickerResult filePickerResult}) async {
    await deleteFilesIfAlreadyPresent();
    final tempDirectory = await getTemporaryDirectory();
    return File(filePickerResult.files.single.path.toString()).copySync(
        '${tempDirectory.path}/$k3dFileName.${filePickerResult.files.single.extension}');
  }

  Future<void> deleteFilesIfAlreadyPresent() async {
    final tempDirectory = await getTemporaryDirectory();

    final fileRef1 =
        File('${tempDirectory.path}/$k3dFileName.${threedAllowedExts[0]}');
    final fileRef2 =
        File('${tempDirectory.path}/$k3dFileName.${threedAllowedExts[1]}');

    if (fileRef1.existsSync()) {
      fileRef1.deleteSync();
    }
    if (fileRef2.existsSync()) {
      fileRef2.deleteSync();
    }
  }
}

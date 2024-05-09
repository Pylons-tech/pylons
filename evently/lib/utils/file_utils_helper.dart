import 'package:evently/models/picked_file_model.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:injectable/injectable.dart';

abstract class FileUtilsHelper {
  /// This function picks a file with the given format from device storage
  /// Input: [format] it is the file format which needs to be picked from local storage
  /// returns [PlatformFile] the selected file or null if aborted
  Future<PickedFileModel> pickFile();
}

@LazySingleton(as: FileUtilsHelper)
class FileUtilsHelperImpl implements FileUtilsHelper {
  ImageCropper imageCropper;
  FilePicker filePicker;

  FileUtilsHelperImpl({required this.imageCropper, required this.filePicker});

  @override
  Future<PickedFileModel> pickFile() async {
    final FilePickerResult? result = await filePicker.pickFiles(type: FileType.image);

    if (result == null) {
      return PickedFileModel(
        path: '',
        fileName: '',
        extension: '',
      );
    }

    if (result.files.single.path != null) {
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

  Future<String> cropImage({required String filePath}) async {
    try {
      final CroppedFile? croppedFile = await imageCropper.cropImage(
        sourcePath: filePath,
        aspectRatioPresets: [CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.original, CropAspectRatioPreset.ratio4x3, CropAspectRatioPreset.ratio16x9],
        uiSettings: [
          AndroidUiSettings(toolbarTitle: kPylons, toolbarColor: EventlyAppTheme.kBlue, toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: false),
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
}

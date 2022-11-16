import 'dart:io';

import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/models/picked_file_model.dart';
import 'package:easel_flutter/utils/file_utils_helper.dart';
import 'package:file_picker/file_picker.dart';

class MockFileUtilsHelperImp implements FileUtilsHelper {
  @override
  Future<File> copyFileToInternal({required FilePickerResult filePickerResult}) {
    throw UnimplementedError();
  }

  @override
  String generateEaselLinkForOpeningInPylonsApp({required String recipeId, required String cookbookId}) {
    throw UnimplementedError();
  }

  @override
  String generateEaselLinkForShare({required String recipeId, required String cookbookId}) {
    throw UnimplementedError();
  }

  @override
  String getFileSizeString({required int fileLength, required int precision}) {
    throw UnimplementedError();
  }

  @override
  Future<void> launchMyUrl({required String url}) {
    throw UnimplementedError();
  }

  @override
  Future<PickedFileModel> pickFile(NftFormat format) {
    throw UnimplementedError();
  }
}

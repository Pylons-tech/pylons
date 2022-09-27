import 'dart:io';

import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/models/picked_file_model.dart';
import 'package:easel_flutter/utils/file_utils_helper.dart';
import 'package:file_picker/file_picker.dart';

class MockFileUtilsHelperImp implements FileUtilsHelper {
  @override
  Future<File> copyFileToInternal({required FilePickerResult filePickerResult}) {
    // TODO: implement copyFileToInternal
    throw UnimplementedError();
  }

  @override
  String generateEaselLinkForOpeningInPylonsApp({required String recipeId, required String cookbookId}) {
    // TODO: implement generateEaselLinkForOpeningInPylonsApp
    throw UnimplementedError();
  }

  @override
  String generateEaselLinkForShare({required String recipeId, required String cookbookId}) {
    // TODO: implement generateEaselLinkForShare
    throw UnimplementedError();
  }

  @override
  String getFileSizeString({required int fileLength, required int precision}) {
    // TODO: implement getFileSizeString
    throw UnimplementedError();
  }

  @override
  Future<void> launchMyUrl({required String url}) {
    // TODO: implement launchMyUrl
    throw UnimplementedError();
  }

  @override
  Future<PickedFileModel> pickFile(NftFormat format) {
    // TODO: implement pickFile
    throw UnimplementedError();
  }
}

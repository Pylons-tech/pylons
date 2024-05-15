import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/models/picked_file_model.dart';
import 'package:evently/models/storage_response_model.dart';
import 'package:evently/services/datasources/local_datasource.dart';
import 'package:evently/services/datasources/remote_datasource.dart';
import 'package:evently/services/third_party_services/quick_node.dart';
import 'package:evently/utils/file_utils_helper.dart';
import 'package:injectable/injectable.dart';

import '../utils/failure/failure.dart';

abstract class Repository {
  /// This function picks a file from device storage
  /// Input: [format] it is the file format which needs to be picked from local storage
  /// returns [PickedFileModel] the selected file or [Failure] if aborted
  Future<Either<Failure, PickedFileModel>> pickFile();

  /// This method will generate evently Id for the event
  /// Output: [String] the id of the Event that is going to be added in the recipe
  String autoGenerateCookbookId();

  /// This method will save the username of the cookbook generator
  /// Input: [username] the username of the user who created the cookbook
  /// Output: [bool] returns whether the operation is successful or not
  Future<bool> saveCookBookGeneratorUsername(String username);

  /// This method will get the already created cookbook from the local database
  /// Output: [String] if the cookbook already exists return cookbook else return null
  String? getCookbookId();

  /// This method will get the username of the cookbook generator
  /// Output: [String] returns whether the operation is successful or not
  String getCookBookGeneratorUsername();

  /// This method will generate easel Id for the NFT
  /// Output: [String] the id of the NFT that is going to be added in the recipe
  String autoGenerateEventlyId();

  /// This method is used uploading provided file to the server using [QuickNode]
  /// Input : [UploadIPFSInput] which needs to be uploaded
  /// Output : [ApiResponse] the ApiResponse which can contain [success] or [error] response
  Future<Either<Failure, StorageResponseModel>> uploadFileUsingQuickNode({required UploadIPFSInput uploadIPFSInput, required OnUploadProgressCallback onUploadProgressCallback});
}

@LazySingleton(as: Repository)
class RepositoryImp implements Repository {
  RepositoryImp({
    required this.fileUtilsHelper,
    required this.localDataSource,
    required this.remoteDataSource,
  });

  final FileUtilsHelper fileUtilsHelper;
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, PickedFileModel>> pickFile() async {
    try {
      final PickedFileModel pickedFileModel = await fileUtilsHelper.pickFile();

      return Right(pickedFileModel);
    } on Exception catch (_) {
      return Left(PickingFileFailure(message: LocaleKeys.picking_file_error.tr()));
    }
  }

  @override
  String autoGenerateCookbookId() => localDataSource.autoGenerateCookbookId();

  @override
  Future<bool> saveCookBookGeneratorUsername(String username) {
    return localDataSource.saveCookBookGeneratorUsername(username);
  }

  @override
  String? getCookbookId() {
    return localDataSource.getCookbookId();
  }

  @override
  String getCookBookGeneratorUsername() {
    return localDataSource.getCookBookGeneratorUsername();
  }

  @override
  String autoGenerateEventlyId() {
    return localDataSource.autoGenerateEventlyId();
  }

  @override
  Future<Either<Failure, StorageResponseModel>> uploadFileUsingQuickNode({required UploadIPFSInput uploadIPFSInput, required OnUploadProgressCallback onUploadProgressCallback}) async {
    try {
      final storageResponseModel = await remoteDataSource.uploadFileUsingQuickNode(uploadIPFSInput: uploadIPFSInput, onUploadProgressCallback: onUploadProgressCallback);
      return Right(storageResponseModel);
    } on Exception catch (_) {
      return Left(CacheFailure(LocaleKeys.update_failed.tr()));
    }
  }
}

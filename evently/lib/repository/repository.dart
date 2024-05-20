import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/models/events.dart';
import 'package:evently/models/picked_file_model.dart';
import 'package:evently/models/storage_response_model.dart';
import 'package:evently/services/datasources/local_datasource.dart';
import 'package:evently/services/datasources/remote_datasource.dart';
import 'package:evently/services/third_party_services/quick_node.dart';
import 'package:evently/utils/file_utils_helper.dart';
import 'package:injectable/injectable.dart';
import 'package:pylons_sdk/low_level.dart';
import '../utils/failure/failure.dart';

abstract class Repository {
  /// This function picks a file from device storage
  /// Input: [format] it is the file format which needs to be picked from local storage
  /// returns [PickedFileModel] the selected file or [Failure] if aborted
  Future<Either<Failure, PickedFileModel>> pickFile();

  /// This method will generate the cookbook id for the easel app
  /// Output: [String] the id of the cookbook which will contains all the NFTs.
  Future<String> autoGenerateCookbookId();

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

  /// This method will get the artist name
  /// Output: [String] returns whether the operation is successful or not
  String getHostName();

  /// This method returns the recipe list
  /// Input : [cookBookId] id of the cookbook
  /// Output: if successful the output will be the list of [pylons.Recipe]
  /// will return error in the form of failure
  Future<Either<Failure, List<Recipe>>> getRecipesBasedOnCookBookId({required String cookBookId});

  /// This method will get the drafts List from the local database
  /// Output: [List] returns that contains a number of [NFT]
  Future<Either<Failure, List<Events>>> getAllEvents();

  /// This method will save event
  /// Output: [int] returns that id of [Event]
  Future<Either<Failure, int>> saveEvents(Events events);

  /// This method will delete draft from the local database
  /// Input: [id] the id of the nft which the user wants to delete
  /// Output: [bool] returns whether the operation is successful or not
  Future<Either<Failure, bool>> deleteNft(int id);

  /// This method will set the input in the cache
  /// Input: [key] the key against which the value is to be set, [value] the value that is to be set.
  bool setCacheDynamicType({required String key, required dynamic value});

  /// This method will set the input in the cache
  /// Input: [key] the key against which the value is to be set, [value] the value that is to be set.
  void setCacheString({required String key, required String value});

  /// This method will return the saved String if exists
  /// Input: [key] the key of the value
  /// Output: [String] the value of the key
  String getCacheString({required String key});

  /// This method will delete the value from the cache
  /// Input: [key] the key of the value
  /// Output: [value] will return the value that is just removed
  String deleteCacheString({required String key});

  /// This method will return the saved String if exists
  /// Input: [key] the key of the value
  /// Output: [String] the value of the key
  dynamic getCacheDynamicType({required String key});
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
  Future<String> autoGenerateCookbookId() async {
    return localDataSource.autoGenerateCookbookId();
  }

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

  @override
  String getHostName() {
    return localDataSource.getHostName();
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipesBasedOnCookBookId({required String cookBookId}) async {
    try {
      final sdkResponse = await remoteDataSource.getRecipesByCookbookID(cookBookId);
      log(sdkResponse.toString(), name: 'pylons_sdk');

      return Right(sdkResponse);
    } on Exception catch (_) {
      return Left(CookBookNotFoundFailure(LocaleKeys.cookbook_not_found.tr()));
    }
  }

  @override
  Future<Either<Failure, List<Events>>> getAllEvents() async {
    try {
      final response = await localDataSource.getAllEvents();
      return Right(response);
    } on Exception catch (_) {
      return Left(CacheFailure(LocaleKeys.something_wrong.tr()));
    }
  }

  @override
  Future<Either<Failure, int>> saveEvents(Events events) async {
    try {
      int id = await localDataSource.saveEvents(events);
      return Right(id);
    } on Exception catch (_) {
      return Left(CacheFailure(LocaleKeys.save_error.tr()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteNft(int id) async {
    try {
      final bool result = await localDataSource.deleteNft(id);
      return Right(result);
    } on Exception catch (_) {
      return Left(CacheFailure(LocaleKeys.something_wrong.tr()));
    }
  }

  @override
  bool setCacheDynamicType({required String key, required dynamic value}) {
    return localDataSource.setCacheDynamicType(key: key, value: value);
  }

  @override
  void setCacheString({required String key, required String value}) {
    localDataSource.setCacheString(key: key, value: value);
  }

  @override
  String getCacheString({required String key}) {
    return localDataSource.getCacheString(key: key);
  }

  @override
  String deleteCacheString({required String key}) {
    return localDataSource.deleteCacheString(key: key);
  }

  @override
  dynamic getCacheDynamicType({required String key}) {
    return localDataSource.getCacheDynamicType(key: key);
  }
}

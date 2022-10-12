import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/api_response.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/models/picked_file_model.dart';
import 'package:easel_flutter/models/save_nft.dart';
import 'package:easel_flutter/services/datasources/local_datasource.dart';
import 'package:easel_flutter/services/datasources/remote_datasource.dart';
import 'package:easel_flutter/services/third_party_services/crashlytics_helper.dart';
import 'package:easel_flutter/services/third_party_services/network_info.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easel_flutter/utils/failure/failure.dart';
import 'package:easel_flutter/utils/file_utils_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

abstract class Repository {
  /// This method returns the recipe list
  /// Input : [cookBookId] id of the cookbook
  /// Output: if successful the output will be the list of [pylons.Recipe]
  /// will return error in the form of failure
  Future<Either<Failure, List<Recipe>>> getRecipesBasedOnCookBookId({required String cookBookId});

  /// This method will return the saved String if exists
  /// Input: [key] the key of the value
  /// Output: [String] the value of the key
  String getCacheString({required String key});

  /// This method will delete the value from the cache
  /// Input: [key] the key of the value
  /// Output: [value] will return the value that is just removed
  String deleteCacheString({required String key});

  /// This method will set the input in the cache
  /// Input: [key] the key against which the value is to be set, [value] the value that is to be set.
  void setCacheString({required String key, required String value});

  /// This method will set the input in the cache
  /// Input: [key] the key against which the value is to be set, [value] the value that is to be set.
  bool setCacheDynamicType({required String key, required dynamic value});

  /// This method will return the saved String if exists
  /// Input: [key] the key of the value
  /// Output: [String] the value of the key
  dynamic getCacheDynamicType({required String key});

  /// This method will delete the value from the cache
  /// Input: [key] the key of the value
  /// Output: [value] will return the value that is just removed
  dynamic deleteCacheDynamic({required String key});

  /// This method will generate the cookbook id for the easel app
  /// Output: [String] the id of the cookbook which will contains all the NFTs.
  Future<String> autoGenerateCookbookId();

  /// This method will save the username of the cookbook generator
  /// Input: [username] the username of the user who created the cookbook
  /// Output: [bool] returns whether the operation is successful or not
  Future<bool> saveCookBookGeneratorUsername(String username);

  /// This method will save the artist name
  /// Input: [name] the name of the artist which the user want to save
  /// Output: [bool] returns whether the operation is successful or not
  Future<bool> saveArtistName(String name);

  /// This method will get the artist name
  /// Output: [String] returns whether the operation is successful or not
  String getArtistName();

  /// This method will get the already created cookbook from the local database
  /// Output: [String] if the cookbook already exists return cookbook else return null
  String? getCookbookId();

  /// This method will get the username of the cookbook generator
  /// Output: [String] returns whether the operation is successful or not
  String getCookBookGeneratorUsername();

  /// This method will generate easel Id for the NFT
  /// Output: [String] the id of the NFT that is going to be added in the recipe
  String autoGenerateEaselId();

  /// This method will save the draft of the NFT
  /// Input: [NFT] the draft that will will be saved in database
  /// Output: [int] returns id of the inserted document & will return error in the form of [Failure]
  Future<Either<Failure, int>> saveNft(NFT nft);

  /// This method will update draft in the local database from description Page
  /// Input:[SaveNft] this model data contains bring [id],[nftName],[nftDescription],[creatorName],[step]
  /// Output: [bool] returns whether the operation is successful or not
  Future<Either<Failure, bool>> updateNftFromDescription({required SaveNft saveNft});

  /// This method will update the draft of the NFT
  /// Input: [id] of the draft that will be updated
  /// Output: [bool] returns that draft that is  updated or not & will return error in the form of [Failure]
  Future<Either<Failure, bool>> updateNFTDialogShown({required int id});

  /// This method will update draft in the local database from Pricing page
  /// Input: [saveNft] contains data to be updated
  /// Output: [bool] returns whether the operation is successful or not & will return error in the form of [Failure]
  Future<Either<Failure, bool>> updateNftFromPrice({required SaveNft saveNft});

  /// This method is used uploading provided file to the server using [httpClient]
  /// Input : [file] which needs to be uploaded , [onUploadProgressCallback] a callback method which needs to be call on each progress
  /// Output : [ApiResponse] the ApiResponse which can contain [success] or [error] response
  Future<Either<Failure, ApiResponse>> uploadFile({required File file, required OnUploadProgressCallback onUploadProgressCallback});

  /// This method will get the drafts List from the local database
  /// Output: [List] returns that contains a number of [NFT]
  Future<Either<Failure, List<NFT>>> getNfts();

  /// This method will get the drafts List from the local database
  /// Input: [id] identifier of the NFt
  /// Output: [NFT] returns the nft else will return [Failure]
  Future<Either<Failure, NFT>> getNft(int id);

  /// This method will delete draft from the local database
  /// Input: [id] the id of the nft which the user wants to delete
  /// Output: [bool] returns whether the operation is successful or not
  Future<Either<Failure, bool>> deleteNft(int id);

  /// This function picks a file with the given format from device storage
  /// Input: [format] it is the file format which needs to be picked from local storage
  /// returns [PickedFileModel] the selected file or [Failure] if aborted
  Future<Either<Failure, PickedFileModel>> pickFile(NftFormat format);

  /// This function checks if a file path extension svg or not
  /// Input: [filePath] the path of selected file
  /// Output: [True] if the filepath has svg extension and [False] otherwise
  String getExtension(String fileName);

  /// This function is used to get the file size in GBs
  /// Input: [fileLength] the file length in bytes
  /// Output: [double] returns the file size in GBs in double format
  double getFileSizeInGB(int fileLength);

  /// This function is used to get the file size in String format
  /// Input: [fileLength] the file length in bytes and [precision] sets to [2] if not given
  /// Output: [String] returns the file size in String format
  String getFileSizeString({required int fileLength, int precision = 2});

  /// This function is used to generate the NFT link to be shared with others after publishing
  /// Input: [recipeId] and [cookbookId] used in the link generation as query parameters
  /// Output: [String] returns the generated NFTs link to be shared with others
  String generateEaselLinkForShare({required String recipeId, required String cookbookId});

  /// This function is used to launch the link generated and open the link in external source platform
  /// Input: [url] is the link to be launched by the launcher
  Future<Either<Failure, void>> launchMyUrl({required String url});

  /// This method will save the on boarding complete
  /// Output: [bool] returns whether the operation is successful or not
  Future<bool> saveOnBoardingComplete();

  /// This method will get the on boarding status
  /// Output: [bool] returns whether the operation is successful or not
  bool getOnBoardingComplete();

  Future<Either<Failure, bool>> logUserJourney({required String screenName});
}

class RepositoryImp implements Repository {
  final NetworkInfo networkInfo;
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final FileUtilsHelper fileUtilsHelper;
  final CrashlyticsHelper crashlyticsHelper;

  RepositoryImp({required this.networkInfo, required this.remoteDataSource, required this.localDataSource, required this.fileUtilsHelper, required this.crashlyticsHelper});

  @override
  Future<Either<Failure, List<Recipe>>> getRecipesBasedOnCookBookId({required String cookBookId}) async {
    if (!await networkInfo.isConnected) {
      return Left(NoInternetFailure("no_internet".tr()));
    }

    try {
      var sdkResponse = await remoteDataSource.getRecipesByCookbookID(cookBookId);
      log(sdkResponse.toString(), name: 'pylons_sdk');

      return Right(sdkResponse);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(CookBookNotFoundFailure("cookbook_not_found".tr()));
    }
  }

  @override
  dynamic deleteCacheDynamic({required String key}) {
    localDataSource.deleteCacheDynamic(key: key);
  }

  @override
  String deleteCacheString({required String key}) {
    return localDataSource.deleteCacheString(key: key);
  }

  @override
  dynamic getCacheDynamicType({required String key}) {
    return localDataSource.getCacheDynamicType(key: key);
  }

  @override
  String getCacheString({required String key}) {
    return localDataSource.getCacheString(key: key);
  }

  @override
  bool setCacheDynamicType({required String key, required value}) {
    return localDataSource.setCacheDynamicType(key: key, value: value);
  }

  @override
  void setCacheString({required String key, required String value}) {
    localDataSource.setCacheString(key: key, value: value);
  }

  @override
  Future<String> autoGenerateCookbookId() async {
    return await localDataSource.autoGenerateCookbookId();
  }

  @override
  Future<bool> saveCookBookGeneratorUsername(String username) {
    return localDataSource.saveCookBookGeneratorUsername(username);
  }

  @override
  Future<bool> saveArtistName(String name) {
    return localDataSource.saveArtistName(name);
  }

  @override
  String getArtistName() {
    return localDataSource.getArtistName();
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
  String autoGenerateEaselId() {
    return localDataSource.autoGenerateEaselId();
  }

  @override
  Future<Either<Failure, int>> saveNft(NFT nft) async {
    try {
      int id = await localDataSource.saveNft(nft);
      return Right(id);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(CacheFailure("save_error".tr()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateNftFromDescription({required SaveNft saveNft}) async {
    try {
      bool result = await localDataSource.updateNftFromDescription(saveNft);

      if (!result) {
        return Left(CacheFailure("upload_error".tr()));
      }
      return Right(result);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(CacheFailure("upload_error".tr()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateNFTDialogShown({required int id}) async {
    try {
      bool result = await localDataSource.updateNFTDialogShown(id);

      if (!result) {
        return Left(CacheFailure("upload_error".tr()));
      }
      return Right(result);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(CacheFailure("upload_error".tr()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateNftFromPrice({required SaveNft saveNft}) async {
    try {
      bool result = await localDataSource.updateNftFromPrice(saveNft);

      return Right(result);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(CacheFailure("upload_error".tr()));
    }
  }

  @override
  Future<Either<Failure, ApiResponse>> uploadFile({required File file, required OnUploadProgressCallback onUploadProgressCallback}) async {
    try {
      ApiResponse apiResponse = await remoteDataSource.uploadFile(file: file, uploadProgressCallback: onUploadProgressCallback);

      return Right(apiResponse);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(CacheFailure("update_failed".tr()));
    }
  }

  @override
  Future<Either<Failure, List<NFT>>> getNfts() async {
    try {
      final response = await localDataSource.getNfts();

      return Right(response);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(CacheFailure("something_wrong".tr()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteNft(int id) async {
    try {
      bool result = await localDataSource.deleteNft(id);
      return Right(result);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(CacheFailure("something_wrong".tr()));
    }
  }

  @override
  Future<Either<Failure, NFT>> getNft(int id) async {
    try {
      NFT? data = await localDataSource.getNft(id);
      if (data == null) {
        return Left(CacheFailure("something_wrong".tr()));
      }
      return Right(data);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(CacheFailure("something_wrong".tr()));
    }
  }

  @override
  Future<Either<Failure, PickedFileModel>> pickFile(NftFormat format) async {
    try {
      PickedFileModel pickedFileModel = await fileUtilsHelper.pickFile(format);

      return Right(pickedFileModel);
    } on Exception catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(PickingFileFailure(message: "picking_file_error".tr()));
    }
  }

  @override
  String getExtension(String fileName) {
    return fileName.getFileExtension();
  }

  @override
  double getFileSizeInGB(int fileLength) {
    return fileLength.getFileSizeInGB();
  }

  @override
  String getFileSizeString({required int fileLength, int precision = 2}) {
    return fileLength.getFileSizeString(precision: precision);
  }

  @override
  String generateEaselLinkForShare({required String recipeId, required String cookbookId}) {
    return recipeId.generateEaselLinkToShare(cookbookId: cookbookId);
  }

  @override
  Future<Either<Failure, void>> launchMyUrl({required String url}) async {
    try {
      final file = await fileUtilsHelper.launchMyUrl(url: url);
      return Right(file);
    } catch (_) {
      crashlyticsHelper.recordFatalError(error: _.toString());
      return Left(UrlLaunchingFileFailure(message: "url_launching_error".tr()));
    }
  }

  @override
  Future<bool> saveOnBoardingComplete() {
    return localDataSource.saveOnBoardingComplete();
  }

  @override
  bool getOnBoardingComplete() {
    return localDataSource.getOnBoardingComplete();
  }

  @override
  Future<Either<Failure, bool>> logUserJourney({required String screenName}) async {
    try {
      return Right(await remoteDataSource.logUserJourney(screenName: screenName));
    } catch (e) {
      return Left(AnalyticsFailure(message: "analytics_failure".tr()));
    }
  }
}

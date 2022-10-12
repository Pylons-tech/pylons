import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/api_response.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/models/nft_format.dart';
import 'package:easel_flutter/models/picked_file_model.dart';
import 'package:easel_flutter/models/save_nft.dart';
import 'package:easel_flutter/repository/repository.dart';
import 'package:easel_flutter/utils/failure/failure.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

import 'mock_constants.dart';

class MockRepositoryImp implements Repository {
  @override
  Future<String> autoGenerateCookbookId() {
    // TODO: implement autoGenerateCookbookId
    throw UnimplementedError();
  }

  @override
  String autoGenerateEaselId() {
    // TODO: implement autoGenerateEaselId
    throw UnimplementedError();
  }

  @override
  deleteCacheDynamic({required String key}) {
    // TODO: implement deleteCacheDynamic
    throw UnimplementedError();
  }

  @override
  String deleteCacheString({required String key}) {
    // TODO: implement deleteCacheString
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteNft(int id) {
    // TODO: implement deleteNft
    throw UnimplementedError();
  }

  @override
  String generateEaselLinkForShare({required String recipeId, required String cookbookId}) {
    // TODO: implement generateEaselLinkForShare
    throw UnimplementedError();
  }

  @override
  String getArtistName() {
    return MOCK_ARTIST_NAME;
  }

  @override
  getCacheDynamicType({required String key}) {
    return MOCK_NFT;
  }

  @override
  String getCacheString({required String key}) {
    // TODO: implement getCacheString
    throw UnimplementedError();
  }

  @override
  String getCookBookGeneratorUsername() {
    // TODO: implement getCookBookGeneratorUsername
    throw UnimplementedError();
  }

  @override
  String? getCookbookId() {
    // TODO: implement getCookbookId
    throw UnimplementedError();
  }

  @override
  String getExtension(String fileName) {
    // TODO: implement getExtension
    throw UnimplementedError();
  }

  @override
  double getFileSizeInGB(int fileLength) {
    // TODO: implement getFileSizeInGB
    throw UnimplementedError();
  }

  @override
  String getFileSizeString({required int fileLength, int precision = 2}) {
    // TODO: implement getFileSizeString
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NFT>> getNft(int id) {
    return Future.value(Right(MOCK_NFT));
  }

  @override
  Future<Either<Failure, List<NFT>>> getNfts() {
    return Future.value(Right([MOCK_NFT]));
  }

  @override
  bool getOnBoardingComplete() {
    // TODO: implement getOnBoardingComplete
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipesBasedOnCookBookId({required String cookBookId}) {
    // TODO: implement getRecipesBasedOnCookBookId
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> launchMyUrl({required String url}) {
    // TODO: implement launchMyUrl
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, PickedFileModel>> pickFile(NftFormat format) {
    // TODO: implement pickFile
    throw UnimplementedError();
  }

  @override
  Future<bool> saveArtistName(String name) {
    return Future.value(true);
  }

  @override
  Future<bool> saveCookBookGeneratorUsername(String username) {
    // TODO: implement saveCookBookGeneratorUsername
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>> saveNft(NFT nft) {
    // TODO: implement saveNft
    throw UnimplementedError();
  }

  @override
  Future<bool> saveOnBoardingComplete() {
    // TODO: implement saveOnBoardingComplete
    throw UnimplementedError();
  }

  @override
  bool setCacheDynamicType({required String key, required value}) {
    return true;
  }

  @override
  void setCacheString({required String key, required String value}) {
    // TODO: implement setCacheString
  }

  @override
  Future<Either<Failure, bool>> updateNFTDialogShown({required int id}) {
    // TODO: implement updateNFTDialogShown
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> updateNftFromDescription({required SaveNft saveNft}) {
    return Future.value(const Right(true));
  }

  @override
  Future<Either<Failure, bool>> updateNftFromPrice({required SaveNft saveNft}) {
    return Future.value(const Right(true));
  }

  @override
  Future<Either<Failure, ApiResponse>> uploadFile({required File file, required OnUploadProgressCallback onUploadProgressCallback}) {
    // TODO: implement uploadFile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> logUserJourney({required String screenName}) async {
    return const Right(true);
  }
}

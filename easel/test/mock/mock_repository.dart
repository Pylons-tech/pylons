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
import 'package:pylons_sdk/low_level.dart';

import 'mock_constants.dart';

class MockRepositoryImp implements Repository {
  @override
  Future<String> autoGenerateCookbookId() {
    throw UnimplementedError();
  }

  @override
  String autoGenerateEaselId() {
    throw UnimplementedError();
  }

  @override
  deleteCacheDynamic({required String key}) {
    throw UnimplementedError();
  }

  @override
  String deleteCacheString({required String key}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteNft(int id) {
    throw UnimplementedError();
  }

  @override
  String generateEaselLinkForShare({required String recipeId, required String cookbookId}) {
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
    throw UnimplementedError();
  }

  @override
  String getCookBookGeneratorUsername() {
    throw UnimplementedError();
  }

  @override
  String? getCookbookId() {
    throw UnimplementedError();
  }

  @override
  String getExtension(String fileName) {
    throw UnimplementedError();
  }

  @override
  double getFileSizeInGB(int fileLength) {
    throw UnimplementedError();
  }

  @override
  String getFileSizeString({required int fileLength, int precision = 2}) {
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
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipesBasedOnCookBookId({required String cookBookId}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> launchMyUrl({required String url}) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, PickedFileModel>> pickFile(NftFormat format) {
    throw UnimplementedError();
  }

  @override
  Future<bool> saveArtistName(String name) {
    return Future.value(true);
  }

  @override
  Future<bool> saveCookBookGeneratorUsername(String username) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>> saveNft(NFT nft) {
    throw UnimplementedError();
  }

  @override
  Future<bool> saveOnBoardingComplete() {
    
    throw UnimplementedError();
  }

  @override
  bool setCacheDynamicType({required String key, required value}) {
    return true;
  }

  @override
  void setCacheString({required String key, required String value}) {
    
  }

  @override
  Future<Either<Failure, bool>> updateNFTDialogShown({required int id}) {
    
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
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> logUserJourney({required String screenName}) async {
    return const Right(true);
  }
}

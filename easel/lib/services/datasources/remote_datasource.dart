import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/models/api_response.dart';
import 'package:easel_flutter/models/storage_response_model.dart';
import 'package:easel_flutter/models/upload_progress.dart';
import 'package:easel_flutter/services/third_party_services/analytics_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pylons_sdk/pylons_sdk.dart';

abstract class RemoteDataSource {
  /// This method is used uploading provided file to the server using [httpClient]
  /// Input : [file] which needs to be uploaded , [onUploadProgressCallback] a callback method which needs to be call on each progress
  /// Output : [Future<ApiResponse<StorageResponseModel>>] the ApiResponse which can contain [success] or [error] response
  Future<ApiResponse<StorageResponseModel>> uploadFile({required OnUploadProgressCallback uploadProgressCallback, required File file});

  /// This method is used to getRecipesList based on CookbookID
  /// Input : [cookBookID] against which recipes needs to be fetched
  /// Output : [Future<List<Recipe>>] which will be a Future list of Recipes against the given [cookbookID]
  Future<List<Recipe>> getRecipesByCookbookID(String cookBookID);

  Future<bool> logUserJourney({required String screenName});
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio httpClient;
  final AnalyticsHelper analyticsHelper;

  RemoteDataSourceImpl({required this.httpClient, required this.analyticsHelper});

  @override
  Future<ApiResponse<StorageResponseModel>> uploadFile({required OnUploadProgressCallback uploadProgressCallback, required File file}) async {
    final response = await httpClient.post(
      "/upload",
      data: Stream.fromIterable(file.readAsBytesSync().map((e) => [e])),
      options: Options(headers: {
        'Content-Length': file.lengthSync().toString(),
      }),
      onSendProgress: (uploaded, total) {
        double uploadedPercentage = uploaded / total;
        uploadProgressCallback(
          UploadProgress(totalSize: total, sendSize: uploaded, uploadedProgressData: uploadedPercentage),
        );
      },
    );

    if (response.statusCode == HttpStatus.ok) {
      final data = StorageResponseModel.fromJson(response.data);
      return ApiResponse<StorageResponseModel>.success(data: data);
    }
    return ApiResponse<StorageResponseModel>.error(
      errorMessage: response.data["error"]["message"] ?? "update_failed".tr(),
    );
  }

  @override
  Future<List<Recipe>> getRecipesByCookbookID(String cookBookID) async {
    var sdkResponse = await PylonsWallet.instance.getRecipes(cookBookID);
    return sdkResponse.data!;
  }

  @override
  Future<bool> logUserJourney({required String screenName}) async {
    return analyticsHelper.logUserJourney(screenName: screenName);
  }
}

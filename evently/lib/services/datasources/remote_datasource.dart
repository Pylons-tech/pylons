import 'package:evently/models/storage_response_model.dart';
import 'package:evently/services/third_party_services/quick_node.dart';
import 'package:injectable/injectable.dart';

abstract class RemoteDataSource {
  /// This method is used uploading provided file to the server using [QuickNode]
  /// Input : [UploadIPFSInput] which needs to be uploaded
  /// Output : [Future<ApiResponse<StorageResponseModel>>] the ApiResponse which can contain [success] or [error] response
  Future<StorageResponseModel> uploadFileUsingQuickNode({required UploadIPFSInput uploadIPFSInput, required OnUploadProgressCallback onUploadProgressCallback});
}

@LazySingleton(as: RemoteDataSource)
class RemoteDataSourceImpl extends RemoteDataSource {
  RemoteDataSourceImpl({required this.quickNode});

  final QuickNode quickNode;

  @override
  Future<StorageResponseModel> uploadFileUsingQuickNode({required UploadIPFSInput uploadIPFSInput, required OnUploadProgressCallback onUploadProgressCallback}) async {
    final response = await quickNode.uploadNewObjectToIPFS(uploadIPFSInput: uploadIPFSInput, onUploadProgressCallback: onUploadProgressCallback);
    return response;
  }
}

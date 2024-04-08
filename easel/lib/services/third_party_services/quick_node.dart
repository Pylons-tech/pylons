import 'dart:async';
import 'package:dio/dio.dart';
import 'package:easel_flutter/easel_provider.dart';
import 'package:easel_flutter/env.dart';
import 'package:easel_flutter/models/storage_response_model.dart';
import 'package:easel_flutter/models/upload_progress.dart';

abstract class QuickNode {
  /// Upload a new object to IPFS and pins it for permanent storage on the network.
  /// [UploadIPFSInput] as an input
  /// [UploadIPFSOutput] as an output
  Future<StorageResponseModel> uploadNewObjectToIPFS({required UploadIPFSInput uploadIPFSInput, required OnUploadProgressCallback onUploadProgressCallback});

  /// these are the list of extension required
  static List<String> listOfQuickNodeAllowedExtension() => [
        ///* images
        'jpg', 'png', 'heif', 'jpeg', 'gif',

        ///* audio
        'mpeg',

        ///*other
        'pdf', 'plain',
      ];

  /// this method is used to get the content type while making request input to quick node
  static String getContentType(String fileExtension) {
    final dict = {
      ///* audio
      'mpeg': "audio/mpeg",

      ///* images
      "jpg": "image/jpg",
      "png": "image/png",
      'heif': "image/heif",
      'jpeg': "image/jpeg",
      'gif': "image/gif",

      ///* others
      "pdf": "application/pdf",
      "plain": "text/plain",
    };
    return dict[fileExtension]!;
  }
}

class QuickNodeImpl extends QuickNode {
  QuickNodeImpl({required this.httpClient});

  final Dio httpClient;

  @override
  Future<StorageResponseModel> uploadNewObjectToIPFS({required UploadIPFSInput uploadIPFSInput, required OnUploadProgressCallback onUploadProgressCallback}) async {
    try {
      httpClient.options.headers['x-api-key'] = xApiKey;

      final response = await httpClient.post(
        'https://api.quicknode.com/ipfs/rest/v1/s3/put-object',
        data: FormData.fromMap({
          'Body': await MultipartFile.fromFile(uploadIPFSInput.filePath),
          'Key': uploadIPFSInput.fileName,
          'ContentType': uploadIPFSInput.contentType,
        }),
        onSendProgress: (uploaded, total) {
          final double uploadedPercentage = uploaded / total;
          onUploadProgressCallback(
            UploadProgress(totalSize: total, sendSize: uploaded, uploadedProgressData: uploadedPercentage),
          );
        },
      );

      final uploadIPFSOutput = UploadIPFSOutput.fromJson(response.data as Map<String, dynamic>);

      return StorageResponseModel.fromQuickNode(uploadIPFSOutput: uploadIPFSOutput);
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }
}

class UploadIPFSInput {
  final String fileName;
  final String filePath;
  final String contentType;

  UploadIPFSInput({
    required this.fileName,
    required this.filePath,
    required this.contentType,
  });
}

class UploadIPFSOutput {
  final String? requestId;
  final String? status;
  final String? created;
  final Pin? pin;
  final Info? info;
  final List<String>? delegates;

  UploadIPFSOutput({this.requestId, this.status, this.created, this.pin, this.info, this.delegates});

  factory UploadIPFSOutput.fromJson(Map<String, dynamic> json) {
    return UploadIPFSOutput(
      requestId: json['requestid'] as String?,
      status: json['status'] as String?,
      created: json['created'] as String?,
      pin: Pin.fromJson(json['pin'] as Map<String, dynamic>),
      info: Info.fromJson(json['info'] as Map<String, dynamic>),
      delegates: [],
    );
  }
}

class Pin {
  String? cid;
  String? name;

  Pin({this.cid, this.name});

  factory Pin.fromJson(Map<String, dynamic> json) => Pin(
        cid: json['cid'] as String?,
        name: json['name'] as String?,
      );
}

class Info {
  final String? size;

  Info({this.size});

  factory Info.fromJson(Map<String, dynamic> json) => Info(size: json['size'] as String?);
}

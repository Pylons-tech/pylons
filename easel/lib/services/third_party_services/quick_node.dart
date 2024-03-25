import 'dart:convert';
import 'dart:io';
import 'package:easel_flutter/models/storage_response_model.dart';

///* using this because dio is already init with other  base url
import 'package:http/http.dart' as http;

abstract class QuickNode {
  /// Upload a new object to IPFS and pins it for permanent storage on the network.
  /// [UploadIPFSInput] as an input
  /// [UploadIPFSOutput] as an output
  Future<StorageResponseModel> uploadNewObjectToIPFS(UploadIPFSInput uploadIPFSInput);

  /// these are the list of extension required
  static List<String> listOfQuickNodeAllowedExtension() {
    return ['pdf', 'mpeg', 'jpg', 'png', 'plain'];
  }

  /// this method is used to get the content type while making request input to quick node
  static String getContentType(String fileExtension) {
    final dict = {"pdf": "application/pdf", "mpeg": " audio/mpeg", "jpg": "image/jpg", "png": "image/png", "plain": "text/plain"};
    return dict[fileExtension] ?? '';
  }
}

class QuickNodeImpl extends QuickNode {
  @override
  Future<StorageResponseModel> uploadNewObjectToIPFS(UploadIPFSInput uploadIPFSInput) async {
    final url = Uri.parse('https://api.quicknode.com/ipfs/rest/v1/s3/put-object');

    final headers = {
      'x-api-key': 'QN_bcb81a5bf4774ea88621cf47c8a06385',
    };

    final fields = {
      'Key': uploadIPFSInput.fileName,
      'ContentType': uploadIPFSInput.contentType,
    };

    final file = File(uploadIPFSInput.filePath);

    final request = http.MultipartRequest('POST', url);

    request.headers.addAll(headers);

    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    final fileStream = http.ByteStream(file.openRead());
    final fileLength = await file.length();
    final multipartFile = http.MultipartFile('Body', fileStream, fileLength, filename: file.path.split('/').last);

    request.files.add(multipartFile);

    final response = await http.Response.fromStream(await request.send());

    final a = UploadIPFSOutput.fromJson(json.decode(response.body) as Map<String, dynamic>);

    return StorageResponseModel.fromQuickNode(uploadIPFSOutput: a);
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

  Map<String, dynamic> toJson() {
    return {};
  }
}

class UploadIPFSOutput {
  final String? requestId;
  final String? status;
  final String? created;
  final Pin? pin;
  final Info? info;
  final List<String>? delegates;

  UploadIPFSOutput({
    this.requestId,
    this.status,
    this.created,
    this.pin,
    this.info,
    this.delegates,
  });

  factory UploadIPFSOutput.fromJson(Map<String, dynamic> json) => UploadIPFSOutput(
        requestId: json['requestid'] as String?,
        status: json['status'] as String?,
        created: json['created'] as String?,
        pin: Pin.fromJson(json['pin'] as Map<String, dynamic>),
        info: Info.fromJson(json['info'] as Map<String, dynamic>),
        delegates: [],
      );
}

class Pin {
  String? cid;
  String? name;

  Pin({
    this.cid,
    this.name,
  });

  factory Pin.fromJson(Map<String, dynamic> json) => Pin(
        cid: json['cid'] as String?,
        name: json['name'] as String?,
      );
}

class Info {
  final String? size;

  Info({
    this.size,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(size: json['size'] as String?);
}

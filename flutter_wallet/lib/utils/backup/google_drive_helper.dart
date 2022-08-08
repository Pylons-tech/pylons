import 'dart:async';
import 'dart:convert';
import 'dart:io' as dt;

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v2.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pylons_wallet/utils/backup/common/backup_model.dart';
import 'package:pylons_wallet/utils/backup/common/i_driver_client.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';

class GoogleDriveApiImpl extends IDriverApi {
  final googleSignIn = GoogleSignIn.standard(scopes: [
    drive.DriveApi.driveAppdataScope,
    drive.DriveApi.driveFileScope,
  ]);

  Future<Either<Failure, drive.DriveApi>> _getDriveApi() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final headers = await googleUser?.authHeaders;
    if (headers == null) {
      return const Left(SignInFailedFailure(message: 'Sign in Failed'));
    }

    final client = GoogleAuthClient(headers);
    final driveApi = drive.DriveApi(client);
    return Right(driveApi);
  }

  @override
  Future<bool> uploadMnemonic(
      {required String mnemonic, required String username}) async {
    final driverEither = await _getDriveApi();
    if (driverEither.isLeft()) {
      throw driverEither.swap().toOption().toNullable()!.message;
    }

    final data = jsonEncode({"username": username, "mnemonic": mnemonic});

    final driveApi = driverEither.toOption().toNullable()!;

    // Create Content
    final Stream<List<int>> mediaStream =
        Future.value(data.codeUnits).asStream().asBroadcastStream();
    final media = drive.Media(mediaStream, data.length);

    // Set up File info
    final drive.File driveFile = createFileData();

    // Upload
    await driveApi.files.create(driveFile, uploadMedia: media);

    return true;
  }

  drive.File createFileData() {
    final driveFile = drive.File();
    driveFile.name = "pylons-mnemonic.txt";
    driveFile.modifiedTime = DateTime.now().toUtc();
    driveFile.parents = ["appDataFolder"];
    return driveFile;
  }

  @override
  Future<BackupData> getBackupData() async {
    final driverEither = await _getDriveApi();
    if (driverEither.isLeft()) {
      throw driverEither.swap().toOption().toNullable()!.message;
    }

    final driveApi = driverEither.toOption().toNullable()!;

    final files = await driveApi.files.list(
      spaces: 'appDataFolder',
      $fields: 'files(id, name, modifiedTime)',
    );

    if (files.files == null || files.files!.isEmpty) {
      throw "no_mnemonic_found".tr();
    }
    final drive.Media response = await driveApi.files.get(
        files.files?.first.id ?? '',
        downloadOptions: DownloadOptions.fullMedia) as Media;

    final List<int> dataStore = [];

    final Completer<BackupData> completer = Completer<BackupData>();

    response.stream.listen((data) {
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () async {
      final dt.Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      final dt.File file = dt.File('$tempPath/test');
      await file.writeAsBytes(dataStore);
      final String content = file.readAsStringSync();
      file.delete();

      completer.complete(BackupData.fromJson(jsonDecode(content) as Map));
    }, onError: (error) {
      completer.completeError(SOMETHING_WENT_WRONG);
    });

    return completer.future;
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

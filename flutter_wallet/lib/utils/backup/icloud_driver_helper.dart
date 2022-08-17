import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' as dt;

import 'package:dartz/dartz.dart';
import 'package:icloud_storage/icloud_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pylons_wallet/utils/backup/common/backup_model.dart';
import 'package:pylons_wallet/utils/backup/common/i_driver_client.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';


class ICloudDriverApiImpl extends IDriverApi {
  Future<Either<Failure, ICloudStorage>> _getDriveApi() async {
    try {
      final iCloudStorage = await ICloudStorage.getInstance('iCloud.pylonsStorage');
      return Right(iCloudStorage);
    } catch (e) {
      return const Left(ICloudInitializationFailedFailure(message: SOMETHING_WENT_WRONG));
    }
  }

  @override
  Future<bool> uploadMnemonic({required String mnemonic, required String username}) async {
    final driverEither = await _getDriveApi();
    if (driverEither.isLeft()) {
      throw driverEither.swap().toOption().toNullable()!.message;
    }

    final driveApi = driverEither.toOption().toNullable()!;

    /// Create Data
    final data = jsonEncode({"username": username, "mnemonic": mnemonic});
    final dt.Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path; //Get path to that location
    final dt.File file = dt.File('$tempPath/pylons_mnemonic.txt'); //Create a dummy file
    await file.writeAsString(data);

    final Completer<bool> completer = Completer();

    await driveApi.startUpload(
      filePath: file.path,
      destinationRelativePath: 'pylons_mnemonic.txt',
      onProgress: (stream) {
        stream.listen(
          (progress) => log('Upload File Progress: $progress'),
          onDone: () {
            file.delete();
            completer.complete(true);
          },
          onError: (err) {
            completer.completeError(err.toString());
          },
          cancelOnError: true,
        );
      },
    );
    return completer.future;
  }

  @override
  Future<BackupData> getBackupData() async {
    final driverEither = await _getDriveApi();
    if (driverEither.isLeft()) {
      throw driverEither.swap().toOption().toNullable()!.message;
    }
    final driveApi = driverEither.toOption().toNullable()!;

    final dt.Directory tempDir = await getTemporaryDirectory();

    final String tempPath = tempDir.path; //Get path to that location
    final dt.File file = dt.File('$tempPath/pylons_mnemonic.txt');

    final Completer<BackupData> completer = Completer();

    await driveApi.startDownload(
      relativePath: 'pylons_mnemonic.txt',
      destinationFilePath: file.path,
      onProgress: (stream) {
        stream.listen(
          (progress) => log('Download File Progress: $progress'),
          onDone: () {
            final String content = file.readAsStringSync(); // Read String from the file
            file.delete();
            completer.complete(BackupData.fromJson(jsonDecode(content) as Map));
          },
          onError: (err) {
            completer.completeError(err.toString());
          },
          cancelOnError: true,
        );
      },
    );

    return completer.future;
  }

}

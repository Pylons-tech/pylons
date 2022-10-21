import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' as dt;

import 'package:icloud_storage/icloud_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pylons_wallet/utils/backup/common/backup_model.dart';
import 'package:pylons_wallet/utils/backup/common/i_driver_client.dart';

class ICloudDriverApiImpl extends IDriverApi {
  String icloudDriverContainer = 'iCloud.pylonsStorage';

  @override
  Future<bool> uploadMnemonic({required String mnemonic, required String username}) async {
    /// Create Data
    final data = jsonEncode({"username": username, "mnemonic": mnemonic});
    final dt.Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path; //Get path to that location
    final dt.File file = dt.File('$tempPath/pylons_mnemonic.txt'); //Create a dummy file
    await file.writeAsString(data);

    final Completer<bool> completer = Completer();

    await ICloudStorage.upload(
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
      containerId: icloudDriverContainer,
    );
    return completer.future;
  }

  @override
  Future<BackupData> getBackupData() async {
    final dt.Directory tempDir = await getTemporaryDirectory();

    final String tempPath = tempDir.path; //Get path to that location
    final dt.File file = dt.File('$tempPath/pylons_mnemonic.txt');

    final Completer<BackupData> completer = Completer();

    await ICloudStorage.download(
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
      containerId: icloudDriverContainer,
    );

    return completer.future;
  }
}

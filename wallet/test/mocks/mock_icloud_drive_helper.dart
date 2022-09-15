import 'package:pylons_wallet/utils/backup/common/backup_model.dart';
import 'package:pylons_wallet/utils/backup/common/i_driver_client.dart';

import 'mock_constants.dart';

class MockICloudDriveHelper extends IDriverApi {
  @override
  Future<BackupData> getBackupData() {
    return Future.value(BackupData(username: MOCK_USERNAME, mnemonic: MOCK_MNEMONIC));
  }

  @override
  Future<bool> uploadMnemonic({required String mnemonic, required String username}) {
    return Future.value(true);
  }
}

import 'package:pylons_wallet/utils/backup/common/backup_model.dart';

abstract class IDriverApi {
  /// This method uploads mnemonic to the iDriver
  /// Input: [mnemonic] the mnemonic to save in the iDriver, [username] the user respective username
  /// Output: [bool] tells whether the operation is successful or not
  Future<bool> uploadMnemonic(
      {required String mnemonic, required String username});

  /// This method uploads mnemonic to the iDriver
  /// Output: return [BackupData] if operation is successful
  /// else throws error
  Future<BackupData> getBackupData();
}

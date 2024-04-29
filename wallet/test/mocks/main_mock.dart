import 'package:mockito/annotations.dart';
import 'package:pylons_wallet/ipc/ipc_engine.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/settings/screens/recovery_screen/screens/practice_test.dart';
import 'package:pylons_wallet/providers/account_provider.dart';
import 'package:pylons_wallet/services/data_stores/local_data_store.dart';
import 'package:pylons_wallet/services/data_stores/remote_data_store.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/connectivity_info.dart';
import 'package:pylons_wallet/services/third_party_services/share_helper.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/backup/google_drive_helper.dart';
import 'package:pylons_wallet/utils/backup/icloud_driver_helper.dart';
import 'package:pylons_wallet/utils/local_auth_helper.dart';
import 'package:pylons_wallet/utils/query_helper.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

@GenerateMocks([
  IPCEngine,
  Repository,
  NFT,
  WalletsStore,
  AccountPublicInfo,
  ShareHelper,
  PracticeTestViewModel,
  GoogleDriveApiImpl,
  ICloudDriverApiImpl,
  LocalAuthHelper,
  LocalDataSource,
  ConnectivityInfoImpl,
  RemoteDataStore,
  QueryHelper,
  AccountProvider,
])
void main() {}

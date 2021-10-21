import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/stores/wallets_store_imp.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/third_party_services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transaction_signing_gateway/alan/alan_credentials_serializer.dart';
import 'package:transaction_signing_gateway/alan/alan_transaction_broadcaster.dart';
import 'package:transaction_signing_gateway/alan/alan_transaction_signer.dart';
import 'package:transaction_signing_gateway/gateway/transaction_signing_gateway.dart';
import 'package:transaction_signing_gateway/mobile/mobile_key_info_storage.dart';
import 'package:transaction_signing_gateway/mobile/no_op_transaction_summary_ui.dart';

final sl = GetIt.instance;

/// This method is used for initializing the dependencies
Future<void> init() async {
  /// Core Logics
  sl.registerLazySingleton<HandlerFactory>(() => HandlerFactory());

  /// Data Sources
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImp(sl()),
  );

  /// External Dependencies
  sl.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());

  sl.registerLazySingleton(() => BaseEnv()
    ..setEnv(
        lcdUrl: dotenv.env['LCD_URL']!,
        grpcUrl: dotenv.env['GRPC_URL']!,
        lcdPort: dotenv.env['LCD_PORT']!,
        grpcPort: dotenv.env['GRPC_PORT']!,
        ethUrl: dotenv.env['ETH_URL']!,
        tendermintPort: dotenv.env['TENDERMINT_PORT']!,
        faucetUrl: dotenv.env['FAUCET_URL'],
        faucetPort: dotenv.env['FAUCET_PORT'],
        wsUrl: dotenv.env['WS_URL']!));

  sl.registerLazySingleton(() => TransactionSigningGateway(
        transactionSummaryUI: NoOpTransactionSummaryUI(),
        signers: [
          AlanTransactionSigner(sl.get<BaseEnv>().networkInfo),
        ],
        broadcasters: [
          AlanTransactionBroadcaster(sl.get<BaseEnv>().networkInfo),
        ],
        infoStorage: MobileKeyInfoStorage(
          serializers: [AlanCredentialsSerializer()],
        ),
      ));



  sl.registerLazySingleton<WalletsStore>(() => WalletsStoreImp(sl(), sl()));
}

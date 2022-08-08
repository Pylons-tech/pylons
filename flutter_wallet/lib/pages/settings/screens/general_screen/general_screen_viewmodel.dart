import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pylons_wallet/ipc/ipc_engine.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/network_info.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/custom_transaction_broadcaster/custom_transaction_broadcaster_imp.dart';
import 'package:pylons_wallet/utils/custom_transaction_signer/custom_transaction_signer.dart';
import 'package:pylons_wallet/utils/custom_transaction_signing_gateaway/custom_transaction_signing_gateway.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:transaction_signing_gateway/alan/alan_account_derivator.dart';
import 'package:transaction_signing_gateway/mobile/no_op_transaction_summary_ui.dart';
import 'package:transaction_signing_gateway/transaction_signing_gateway.dart';

class GeneralScreenViewModel extends ChangeNotifier {
  bool dropdownVisibility = false;

  String _selectedValue = kTestNet;

  String get selectedValue => _selectedValue;

  set selectedValue(String value) {
    _selectedValue = value;
    notifyListeners();
  }

  void changeSelectedValue() {
    _selectedValue = _selectedValue == kDevNet ? kTestNet : kDevNet;
    changeDropdownVisibility();
  }

  void changeDropdownVisibility() {
    dropdownVisibility = !dropdownVisibility;
    notifyListeners();
  }

  void getSelectedValue() {
    final networkPreferenceEither =
        GetIt.I.get<Repository>().getNetworkEnvironmentPreference();

    final networkPreference = networkPreferenceEither.getOrElse(() => "");

    if (networkPreference == kDevNet) {
      selectedValue = kDevNet;
    } else {
      selectedValue = kTestNet;
    }
  }

  Future<void> changeAppEnvConfiguration() async {
    await GetIt.I
        .get<Repository>()
        .saveNetworkEnvironmentPreference(networkEnvironment: _selectedValue);
    addingDependenciesAgain();
  }

  Future<void> addingDependenciesAgain() async {
    await sl.resetLazySingleton<BaseEnv>();

    sl.resetLazySingleton<AlanTransactionSigner>();
    sl.resetLazySingleton<AlanAccountDerivator>();
    sl.resetLazySingleton<AlanTransactionBroadcaster>();
    sl.resetLazySingleton<TransactionSigningGateway>();
    sl.resetLazySingleton<CustomTransactionSigningGateway>();
    sl.resetLazySingleton<CustomTransactionSigner>();
    sl.resetLazySingleton<CustomTransactionBroadcasterImp>();
    sl.resetLazySingleton<CosmosKeyInfoStorage>();

    sl.resetLazySingleton<InternetConnectionChecker>();
    sl.resetLazySingleton<NetworkInfo>();
    sl.resetLazySingleton<IPCEngine>();

    sl.resetLazySingleton<FlutterSecureStorage>();

    sl.resetLazySingleton<http.Client>();
    sl.resetLazySingleton<SharedPrefsPlainDataStore>();
    sl.resetLazySingleton<NoOpTransactionSummaryUI>();
    sl.resetLazySingleton<CustomTransactionSigner>();

    sl.resetLazySingleton<FlutterSecureStorageDataStore>();
    sl.resetLazySingleton<AlanCredentialsSerializer>();

    sl.resetLazySingleton<TransactionSigningGateway>();

    sl.resetLazySingleton<CustomTransactionSigningGateway>();
  }
}

import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/utils/third_party_services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

/// This method is used for initializing the dependencies
Future<void> init() async {
  /// Data Sources

  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImp(sl()),
  );

  /// External Dependencies
  sl.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());
}

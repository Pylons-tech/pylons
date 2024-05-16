// coverage: false
// coverage:ignore-file

import 'package:evently/services/third_party_services/database.dart';
import 'package:evently/utils/di/di.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Service Locator for  project
final sl = GetIt.I;

// initialization of Service locator
@InjectableInit()
void configureDependencies() {
  sl.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());
  sl.registerSingletonAsync<AppDatabase>(() => $FloorAppDatabase.databaseBuilder('app_database.db').build());
  sl.init();
}

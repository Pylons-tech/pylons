import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pylons_wallet/components/user_image_widget_viewmodel.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/ipc_engine.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view_view_model.dart';
import 'package:pylons_wallet/pages/home/home_provider.dart';
import 'package:pylons_wallet/pages/presenting_onboard_page/viewmodel/accept_policy_viewmodel.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart';
import 'package:pylons_wallet/pages/settings/screens/general_screen/general_screen_localization_view_model.dart';
import 'package:pylons_wallet/pages/settings/screens/general_screen/general_screen_viewmodel.dart';
import 'package:pylons_wallet/pages/settings/screens/recovery_screen/screens/practice_test.dart';
import 'package:pylons_wallet/pages/settings/utils/user_info_provider.dart';
import 'package:pylons_wallet/pages/transaction_failure_manager/failure_manager_view_model.dart';
import 'package:pylons_wallet/providers/account_provider.dart';
import 'package:pylons_wallet/providers/collections_tab_provider.dart';
import 'package:pylons_wallet/services/data_stores/local_data_store.dart';
import 'package:pylons_wallet/services/data_stores/remote_data_store.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/analytics_helper.dart';
import 'package:pylons_wallet/services/third_party_services/audio_player_helper.dart';
import 'package:pylons_wallet/services/third_party_services/connectivity_info.dart';
import 'package:pylons_wallet/services/third_party_services/crashlytics_helper.dart';
import 'package:pylons_wallet/services/third_party_services/firestore_helper.dart';
import 'package:pylons_wallet/services/third_party_services/remote_config_service/remote_config_service.dart';
import 'package:pylons_wallet/services/third_party_services/remote_notifications_service.dart';
import 'package:pylons_wallet/services/third_party_services/share_helper.dart';
import 'package:pylons_wallet/services/third_party_services/store_payment_service.dart';
import 'package:pylons_wallet/services/third_party_services/stripe_handler.dart';
import 'package:pylons_wallet/services/third_party_services/thumbnail_helper.dart';
import 'package:pylons_wallet/services/third_party_services/video_player_helper.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/stores/wallet_store_imp.dart';
import 'package:pylons_wallet/utils/backup/google_drive_helper.dart';
import 'package:pylons_wallet/utils/backup/icloud_driver_helper.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/custom_transaction_broadcaster/custom_transaction_broadcaster_imp.dart';
import 'package:pylons_wallet/utils/custom_transaction_signer/custom_transaction_signer.dart';
import 'package:pylons_wallet/utils/custom_transaction_signing_gateaway/custom_transaction_signing_gateway.dart';
import 'package:pylons_wallet/utils/local_auth_helper.dart';
import 'package:pylons_wallet/utils/permission_service.dart';
import 'package:pylons_wallet/utils/query_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transaction_signing_gateway/alan/alan_account_derivator.dart';
import 'package:transaction_signing_gateway/alan/alan_credentials_serializer.dart';
import 'package:transaction_signing_gateway/alan/alan_transaction_broadcaster.dart';
import 'package:transaction_signing_gateway/alan/alan_transaction_signer.dart';
import 'package:transaction_signing_gateway/gateway/transaction_signing_gateway.dart';
import 'package:transaction_signing_gateway/mobile/no_op_transaction_summary_ui.dart';
import 'package:transaction_signing_gateway/storage/cosmos_key_info_storage.dart';
import 'package:transaction_signing_gateway/storage/flutter_secure_storage_data_store.dart';
import 'package:transaction_signing_gateway/storage/shared_prefs_plain_data_store.dart';
import 'package:video_player/video_player.dart';

import '../../ipc/local_server.dart';
import '../../services/third_party_services/database/database.dart';
import '../types.dart';

final sl = GetIt.instance;

/// This method is used for initializing the dependencies
Future<void> init({
  required OnLogEvent onLogEvent,
  required OnLogError onLogError,
  required OnLogMessage onLogMessage,
}) async {
  /// Services
  sl.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(
        checkTimeout: const Duration(seconds: 20)),
  );
  sl.registerLazySingleton<ConnectivityInfoImpl>(
      () => ConnectivityInfoImpl(sl()));
  sl.registerLazySingleton<IPCEngine>(() => IPCEngine(
        repository: sl(),
        walletsStore: sl(),
        accountProvider: sl<AccountProvider>(),
        onLogEvent: onLogEvent,
        onLogError: onLogError,
      ));
  sl.registerLazySingleton<LocalServer>(
      () => LocalServer(sl<HandlerFactory>()));
  sl.registerFactory<AudioPlayerHelper>(() => AudioPlayerHelperImpl(sl()));
  sl.registerFactory<VideoPlayerHelper>(() => VideoPlayerHelperImp(sl()));
  sl.registerFactory<ThumbnailHelper>(() => ThumbnailHelperImp());
  sl.registerLazySingleton<CrashlyticsHelper>(
      () => CrashlyticsHelperImpl(sl()));
  sl.registerFactory<ShareHelper>(() => ShareHelperImpl());
  sl.registerLazySingleton<RemoteNotificationsProvider>(
      () => RemoteNotificationsProvider(
            firebaseMessaging: sl(),
            flutterLocalNotificationsPlugin: sl(),
            repository: sl(),
          ));
  sl.registerLazySingleton<FirestoreHelper>(
      () => FirestoreHelperImp(mainFeedbacksCollection: sl()));
  sl.registerLazySingleton<AnalyticsHelper>(
      () => AnalyticsHelperImpl(firebaseAnalytics: sl()));

  /// External Dependencies
  sl.registerLazySingleton<FlutterLocalNotificationsPlugin>(
      () => FlutterLocalNotificationsPlugin());
  sl.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);
  sl.registerLazySingleton<ImagePicker>(() => ImagePicker());
  sl.registerLazySingleton<LocalAuthentication>(() => LocalAuthentication());
  sl.registerSingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance());
  sl.registerLazySingleton<GoogleDriveApiImpl>(() => GoogleDriveApiImpl());
  sl.registerLazySingleton<ICloudDriverApiImpl>(() => ICloudDriverApiImpl());
  sl.registerLazySingleton(() => FirebaseRemoteConfig.instance);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerFactory<AudioPlayer>(() => AudioPlayer());
  sl.registerFactory<VideoPlayerController>(
      () => VideoPlayerController.networkUrl(Uri(host: "")));
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<AlanTransactionSigner>(
      () => AlanTransactionSigner(sl.get<BaseEnv>().networkInfo));
  sl.registerLazySingleton<AlanTransactionBroadcaster>(
      () => AlanTransactionBroadcaster(sl.get<BaseEnv>().networkInfo));
  sl.registerLazySingleton<SharedPrefsPlainDataStore>(
      () => SharedPrefsPlainDataStore());
  sl.registerLazySingleton<NoOpTransactionSummaryUI>(
      () => NoOpTransactionSummaryUI());
  sl.registerLazySingleton<CustomTransactionSigner>(
      () => CustomTransactionSigner(sl.get<BaseEnv>().networkInfo));
  sl.registerLazySingleton<CustomTransactionBroadcasterImp>(
      () => CustomTransactionBroadcasterImp(sl.get<BaseEnv>().networkInfo));
  sl.registerLazySingleton(() => FirebaseCrashlytics.instance);
  sl.registerLazySingleton<AlanAccountDerivator>(() => AlanAccountDerivator());
  sl.registerLazySingleton<FirebaseDynamicLinks>(
      () => FirebaseDynamicLinks.instance);
  sl.registerLazySingleton<CollectionReference>(
      () => FirebaseFirestore.instance.collection(kFeedbacks));
  sl.registerLazySingleton<FirebaseAnalytics>(() => FirebaseAnalytics.instance);
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  sl.registerSingleton<AppDatabase>(database);

  sl.registerLazySingleton<FlutterSecureStorageDataStore>(
      () => FlutterSecureStorageDataStore(storage: sl()));
  sl.registerLazySingleton<AlanCredentialsSerializer>(
      () => AlanCredentialsSerializer());

  sl.registerLazySingleton<CosmosKeyInfoStorage>(() => CosmosKeyInfoStorage(
        serializers: [sl.get<AlanCredentialsSerializer>()],
        plainDataStore: sl.get<SharedPrefsPlainDataStore>(),
        secureDataStore: sl.get<FlutterSecureStorageDataStore>(),
      ));

  sl.registerLazySingleton(() => TransactionSigningGateway(
      transactionSummaryUI: sl<NoOpTransactionSummaryUI>(),
      signers: [sl.get<AlanTransactionSigner>()],
      broadcasters: [sl.get<AlanTransactionBroadcaster>()],
      infoStorage: sl.get<CosmosKeyInfoStorage>(),
      derivators: [sl.get<AlanAccountDerivator>()]));

  sl.registerLazySingleton(() => CustomTransactionSigningGateway(
        transactionSummaryUI: sl<NoOpTransactionSummaryUI>(),
        derivators: [sl.get<AlanAccountDerivator>()],
        signers: [
          sl.get<CustomTransactionSigner>(),
        ],
        broadcasters: [
          sl.get<CustomTransactionBroadcasterImp>(),
        ],
        infoStorage: sl.get<CosmosKeyInfoStorage>(),
      ));

  /// Core Logics
  sl.registerLazySingleton<HandlerFactory>(() => HandlerFactory());
  sl.registerLazySingleton<AccountProvider>(
    () => AccountProvider(
      transactionSigningGateway: sl<TransactionSigningGateway>(),
    ),
  );

  /// Data Sources
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImp(
      picker: sl(),
      sharedPreferences: sl(),
      flutterSecureStorage: sl(),
      permissionService: sl(),
      database: sl(),
    ),
  );

  sl.registerLazySingleton<PermissionService>(
    () => PermissionsServiceImp(),
  );

  await sl.isReady<SharedPreferences>();

  final remoteConfigService = RemoteConfigServiceImpl(
      firebaseRemoteConfig: sl(), crashlyticsHelper: sl());
  await remoteConfigService.init();

  sl.registerLazySingleton<RemoteConfigService>(
    () => remoteConfigService,
  );

  sl.registerLazySingleton<LocalAuthHelper>(
    () => LocalAuthHelperImp(sl()),
  );

  sl.registerLazySingleton<RemoteDataStore>(() => RemoteDataStoreImp(
        httpClient: sl(),
        storePaymentService: sl(),
        dynamicLinksGenerator: sl(),
        firebaseHelper: sl(),
        analyticsHelper: sl(),
        onLogError: onLogError,
      ));

  sl.registerLazySingleton<StorePaymentService>(
      () => StorePaymentServiceImpl());

  sl.registerLazySingleton<QueryHelper>(() => QueryHelper(httpClient: sl()));

  /// Repository
  sl.registerLazySingleton<Repository>(
    () => RepositoryImp(
      networkInfo: sl(),
      queryHelper: sl(),
      remoteDataStore: sl(),
      localDataSource: sl(),
      localAuthHelper: sl(),
      googleDriveApi: sl(),
      iCloudDriverApi: sl(),
      onLogError: onLogError,
      getBaseEnv: () => sl.get<BaseEnv>(),
    ),
  );

  /// ViewModels
  sl.registerLazySingleton<WalletsStore>(
    () => WalletsStoreImp(
        repository: sl(),
        crashlyticsHelper: sl(),
        accountProvider: sl(),
        remoteNotificationProvider: sl()),
  );
  sl.registerFactory(
    () => PurchaseItemViewModel(sl(),
        audioPlayerHelper: sl(),
        videoPlayerHelper: sl(),
        repository: sl(),
        shareHelper: sl(),
        accountPublicInfo: sl<AccountProvider>().accountPublicInfo),
  );
  sl.registerLazySingleton(() => StripeHandler(
      walletsStore: sl(),
      localDataSource: sl(),
      repository: sl(),
      accountProvider: sl()));
  sl.registerLazySingleton(() => HomeProvider(
      repository: sl(),
      accountPublicInfo: sl<AccountProvider>().accountPublicInfo!));
  sl.registerLazySingleton(() => GeneralScreenViewModel());
  sl.registerLazySingleton(
      () => UserInfoProvider(sl<IPCEngine>(), sl<LocalServer>()));
  sl.registerLazySingleton(() => GeneralScreenLocalizationViewModel(
      shareHelper: sl(), repository: sl(), walletStore: sl()));
  sl.registerLazySingleton(() => PracticeTestViewModel(sl()));
  sl.registerLazySingleton(() => FailureManagerViewModel(repository: sl()));
  sl.registerFactory(() => OwnerViewViewModel(
        repository: sl(),
        walletsStore: sl(),
        audioPlayerHelper: sl(),
        videoPlayerHelper: sl(),
        shareHelper: sl(),
        accountPublicInfo: sl<AccountProvider>().accountPublicInfo!,
      ));
  sl.registerLazySingleton(() => UserBannerViewModel());
  sl.registerLazySingleton(() => CollectionsTabProvider());
  sl.registerLazySingleton(
      () => AcceptPolicyViewModel(repository: sl(), walletsStore: sl()));

  /// Configurations
  sl.registerLazySingleton<BaseEnv>(() => remoteConfigService.getBaseEnv());
}

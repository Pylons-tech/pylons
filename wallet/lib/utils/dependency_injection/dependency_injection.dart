import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
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
import 'package:pylons_wallet/pages/home/collection_screen/collection_view_model.dart';
import 'package:pylons_wallet/pages/home/home_provider.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart';
import 'package:pylons_wallet/pages/settings/screens/general_screen/general_screen_localization_view_model.dart';
import 'package:pylons_wallet/pages/settings/screens/general_screen/general_screen_viewmodel.dart';
import 'package:pylons_wallet/pages/settings/screens/recovery_screen/screens/practice_test.dart';
import 'package:pylons_wallet/pages/settings/utils/user_info_provider.dart';
import 'package:pylons_wallet/services/data_stores/local_data_store.dart';
import 'package:pylons_wallet/services/data_stores/remote_data_store.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/audio_player_helper.dart';
import 'package:pylons_wallet/services/third_party_services/crashlytics_helper.dart';
import 'package:pylons_wallet/services/third_party_services/firestore_helper.dart';
import 'package:pylons_wallet/services/third_party_services/network_info.dart';
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

final sl = GetIt.instance;

/// This method is used for initializing the dependencies
Future<void> init() async {
  /// Services
  sl.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<IPCEngine>(() => IPCEngine(repository: sl(), walletsStore: sl()));
  sl.registerFactory<AudioPlayerHelper>(() => AudioPlayerHelperImpl(sl()));
  sl.registerFactory<VideoPlayerHelper>(() => VideoPlayerHelperImp(sl()));
  sl.registerFactory<ThumbnailHelper>(() => ThumbnailHelperImp());
  sl.registerLazySingleton<CrashlyticsHelper>(() => CrashlyticsHelperImpl(sl()));
  sl.registerFactory<ShareHelper>(() => ShareHelperImpl());
  sl.registerLazySingleton<RemoteNotificationsService>(() => RemoteNotificationsServiceImp(firebaseMessaging: sl(), flutterLocalNotificationsPlugin: sl()));

  /// External Dependencies
  sl.registerLazySingleton<FirebaseAppCheck>(() => FirebaseAppCheck.instance);
  sl.registerLazySingleton<FlutterLocalNotificationsPlugin>(() => FlutterLocalNotificationsPlugin());
  sl.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);
  sl.registerLazySingleton<ImagePicker>(() => ImagePicker());
  sl.registerLazySingleton<LocalAuthentication>(() => LocalAuthentication());
  sl.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());
  sl.registerLazySingleton<GoogleDriveApiImpl>(() => GoogleDriveApiImpl());
  sl.registerLazySingleton<ICloudDriverApiImpl>(() => ICloudDriverApiImpl());
  sl.registerLazySingleton(() => FirebaseRemoteConfig.instance);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerFactory<AudioPlayer>(() => AudioPlayer());
  sl.registerFactory<VideoPlayerController>(() => VideoPlayerController.network(''));
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<AlanTransactionSigner>(() => AlanTransactionSigner(sl.get<BaseEnv>().networkInfo));
  sl.registerLazySingleton<AlanTransactionBroadcaster>(() => AlanTransactionBroadcaster(sl.get<BaseEnv>().networkInfo));
  sl.registerLazySingleton<SharedPrefsPlainDataStore>(() => SharedPrefsPlainDataStore());
  sl.registerLazySingleton<NoOpTransactionSummaryUI>(() => NoOpTransactionSummaryUI());
  sl.registerLazySingleton<CustomTransactionSigner>(() => CustomTransactionSigner(sl.get<BaseEnv>().networkInfo));
  sl.registerLazySingleton<CustomTransactionBroadcasterImp>(() => CustomTransactionBroadcasterImp(sl.get<BaseEnv>().networkInfo));
  sl.registerLazySingleton(() => FirebaseCrashlytics.instance);
  sl.registerLazySingleton<AlanAccountDerivator>(() => AlanAccountDerivator());
  sl.registerLazySingleton<FirebaseDynamicLinks>(() => FirebaseDynamicLinks.instance);
  sl.registerLazySingleton<CollectionReference>(() => FirebaseFirestore.instance.collection(kFeedbacks));
  sl.registerLazySingleton<FirestoreHelper>(() => FirestoreHelperImp(mainFeedbacksCollection: sl()));

  sl.registerLazySingleton<FlutterSecureStorageDataStore>(() => FlutterSecureStorageDataStore(storage: sl()));
  sl.registerLazySingleton<AlanCredentialsSerializer>(() => AlanCredentialsSerializer());

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

  /// Data Sources
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImp(picker: sl(), sharedPreferences: sl(), flutterSecureStorage: sl(), permissionService: sl()),
  );

  sl.registerLazySingleton<PermissionService>(
    () => PermissionsServiceImp(),
  );

  await sl.isReady<SharedPreferences>();

  final remoteConfigService = RemoteConfigServiceImpl(firebaseRemoteConfig: sl(), localDataSource: sl(), crashlyticsHelper: sl());
  await remoteConfigService.init();

  sl.registerLazySingleton<RemoteConfigService>(
    () => remoteConfigService,
  );

  sl.registerLazySingleton<LocalAuthHelper>(
    () => LocalAuthHelperImp(sl()),
  );

  sl.registerLazySingleton<RemoteDataStore>(() => RemoteDataStoreImp(
        httpClient: sl(),
        crashlyticsHelper: sl(),
        storePaymentService: sl(),
        firebaseAppCheck: sl(),
        dynamicLinksGenerator: sl(),
        firebaseHelper: sl(),
      ));

  sl.registerLazySingleton<StorePaymentService>(() => StorePaymentServiceImpl());

  sl.registerLazySingleton<QueryHelper>(() => QueryHelper(httpClient: sl()));

  /// Repository
  sl.registerLazySingleton<Repository>(() =>
      RepositoryImp(networkInfo: sl(), queryHelper: sl(), remoteDataStore: sl(), localDataSource: sl(), localAuthHelper: sl(), googleDriveApi: sl(), iCloudDriverApi: sl(), crashlyticsHelper: sl()));

  /// ViewModels
  sl.registerLazySingleton<WalletsStore>(() => WalletsStoreImp(
        repository: sl(),
        crashlyticsHelper: sl(),
      ));
  sl.registerFactory(() => PurchaseItemViewModel(
        sl(),
        audioPlayerHelper: sl(),
        videoPlayerHelper: sl(),
        repository: sl(),
        shareHelper: sl(),
      ));
  sl.registerLazySingleton(() => CollectionViewModel(walletsStore: sl(), thumbnailHelper: sl()));
  sl.registerLazySingleton(() => StripeHandler(walletsStore: sl(), localDataSource: sl(), repository: sl()));
  sl.registerLazySingleton(() => HomeProvider(walletStore: sl(), repository: sl()));
  sl.registerLazySingleton(() => GeneralScreenViewModel());
  sl.registerLazySingleton(() => UserInfoProvider(sl()));
  sl.registerLazySingleton(() => GeneralScreenLocalizationViewModel(shareHelper: sl(), repository: sl(), walletStore: sl()));
  sl.registerLazySingleton(() => PracticeTestViewModel(sl()));
  sl.registerFactory(() => OwnerViewViewModel(
        repository: sl(),
        walletsStore: sl(),
        audioPlayerHelper: sl(),
        videoPlayerHelper: sl(),
        shareHelper: sl(),
      ));
  sl.registerLazySingleton(() => UserBannerViewModel());

  /// Configurations
  sl.registerLazySingleton<BaseEnv>(() => remoteConfigService.getBaseEnv());
}

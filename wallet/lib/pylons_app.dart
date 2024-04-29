import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/components/no_internet.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/create_trade_bottom_sheet.dart';
import 'package:pylons_wallet/pages/home/home_provider.dart';
import 'package:pylons_wallet/pages/settings/utils/user_info_provider.dart';
import 'package:pylons_wallet/providers/account_provider.dart';
import 'package:pylons_wallet/providers/items_provider.dart';
import 'package:pylons_wallet/providers/recipes_provider.dart';
import 'package:pylons_wallet/services/data_stores/remote_data_store.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/remote_notifications_service.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/base_env.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import 'package:pylons_wallet/utils/types.dart';

import 'generated/locale_keys.g.dart';
import 'model/transaction_failure_model.dart';
import 'providers/collections_tab_provider.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey();

final noInternet = NoInternetDialog();

class PylonsApp extends StatefulWidget {
  const PylonsApp({required this.onLogMessage});
  @override
  State<PylonsApp> createState() => _PylonsAppState();

  final OnLogMessage onLogMessage;
}

class _PylonsAppState extends State<PylonsApp> with WidgetsBindingObserver {
  AppLifecycleState _appState = AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    GetIt.I.get<Repository>().setApplicationDirectory();
    checkInternetConnectivity();
    setUpNotifications();
    InAppPurchase.instance.purchaseStream.listen(onEvent);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      builder: (_, __) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: sl<UserInfoProvider>(),
          ),
          Provider(
            create: (context) => sl<RemoteNotificationsProvider>(),
          ),
          ChangeNotifierProvider<AccountProvider>.value(
            value: sl<AccountProvider>(),
          ),
          ChangeNotifierProxyProvider<AccountProvider, RecipesProvider>(
            create: (BuildContext context) => RecipesProvider(
              repository: sl<Repository>(),
              address: null,
            ),
            update: (
              BuildContext context,
              AccountProvider accountProvider,
              RecipesProvider? recipesProvider,
            ) {
              final receipeProvider = RecipesProvider.fromAccountProvider(
                accountPublicInfo: accountProvider.accountPublicInfo,
                repository: sl<Repository>(),
              );
              if (sl.isRegistered<RecipesProvider>()) {
                sl.unregister<RecipesProvider>();
              }

              sl.registerSingleton(receipeProvider);
              return receipeProvider;
            },
          ),
          ChangeNotifierProxyProvider<AccountProvider, ItemsProvider>(
            create: (BuildContext context) => ItemsProvider(
              repository: sl<Repository>(),
              address: null,
            ),
            update: (
              BuildContext context,
              AccountProvider accountProvider,
              ItemsProvider? itemsProvider,
            ) {
              final itemsProvider = ItemsProvider.fromAccountProvider(
                accountPublicInfo: accountProvider.accountPublicInfo,
                repository: sl<Repository>(),
              );
              if (sl.isRegistered<ItemsProvider>()) {
                sl.unregister<ItemsProvider>();
              }
              sl.registerSingleton(itemsProvider);
              return itemsProvider;
            },
          ),
          ChangeNotifierProvider.value(value: sl.get<CollectionsTabProvider>()),
          Provider<WalletsStore>.value(
            value: sl<WalletsStore>(),
          ),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: "Pylons Wallet",
          theme: PylonsAppTheme().buildAppTheme(),
          initialRoute: '/',
          onGenerateRoute: (settings) {
            widget.onLogMessage("Navigated to ${settings.name}: ${settings.arguments}");
            return RouteUtil.onGenerateRoute(settings);
          },
          builder: (context, widget) {
            return Material(
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
                child: widget ?? Container(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appState = state;
    });
  }

  Future onEvent(List<PurchaseDetails> event) async {
    final navigator = Navigator.of(navigatorKey.currentState!.overlay!.context);
    if (event.isEmpty) {
      return;
    }

    for (final purchaseDetails in event) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.purchased:
          await handlerPurchaseEvent(purchaseDetails);
          break;
        case PurchaseStatus.error:
          if (purchaseDetails.error!.message.contains(kItemAlreadyOwned)) {
            LocaleKeys.please_try_again_later.tr().show();
            return;
          }
          registerFailure(purchaseDetails);
          purchaseDetails.error?.message.show();
          await Future.delayed(const Duration(seconds: 2));
          navigator.pushNamed(Routes.transactionFailure.name);

          break;
        case PurchaseStatus.restored:
          break;
        case PurchaseStatus.canceled:
          break;
      }
    }
  }

  Future<void> saveTransactionRecord({
    required String transactionHash,
    required TransactionStatus transactionStatus,
    required LocalTransactionModel txLocalModel,
  }) async {
    final repository = GetIt.I.get<Repository>();
    final txLocalModelWithStatus = LocalTransactionModel.fromStatus(
      transactionHash: transactionHash,
      status: transactionStatus,
      transactionModel: txLocalModel,
    );
    await repository.saveLocalTransaction(txLocalModelWithStatus);
  }

  Future<void> registerFailure(PurchaseDetails purchaseDetails) async {
    final wallet = sl<AccountProvider>().accountPublicInfo;

    if (wallet == null) {
      return;
    }

    if (purchaseDetails is GooglePlayPurchaseDetails) {
      final price = getInAppPrice(purchaseDetails.productID);
      final creator = wallet.publicAddress;

      final GoogleInAppPurchaseModel googleInAppPurchaseModel = GoogleInAppPurchaseModel(
        productID: purchaseDetails.productID,
        purchaseToken: purchaseDetails.verificationData.serverVerificationData,
        receiptData: jsonDecode(purchaseDetails.verificationData.localVerificationData) as Map,
        signature: purchaseDetails.billingClientPurchase.signature,
        creator: creator,
      );

      final LocalTransactionModel localTransactionModel = createInitialLocalTransactionModel(
        transactionTypeEnum: TransactionTypeEnum.GoogleInAppCoinsRequest,
        transactionData: jsonEncode(googleInAppPurchaseModel.toJsonLocalRetry()),
        transactionDescription: LocaleKeys.buying_pylon_points.tr(),
        transactionCurrency: kStripeUSD_ABR,
        transactionPrice: price,
      );
      saveTransactionRecord(
        transactionHash: '',
        transactionStatus: TransactionStatus.Failed,
        txLocalModel: localTransactionModel,
      );
    }

    if (purchaseDetails is AppStorePurchaseDetails) {
      final price = getInAppPrice(purchaseDetails.productID);
      final creator = wallet.publicAddress;

      final AppleInAppPurchaseModel appleInAppPurchaseModel = AppleInAppPurchaseModel(
        productID: purchaseDetails.productID,
        purchaseID: purchaseDetails.purchaseID ?? '',
        receiptData: purchaseDetails.verificationData.localVerificationData,
        creator: creator,
      );

      final LocalTransactionModel localTransactionModel = createInitialLocalTransactionModel(
          transactionTypeEnum: TransactionTypeEnum.AppleInAppCoinsRequest,
          transactionData: jsonEncode(appleInAppPurchaseModel.toJson()),
          transactionDescription: LocaleKeys.buying_pylon_points.tr(),
          transactionCurrency: kStripeUSD_ABR,
          transactionPrice: price);

      saveTransactionRecord(
        transactionHash: '',
        transactionStatus: TransactionStatus.Failed,
        txLocalModel: localTransactionModel,
      );
    }
  }

  String getInAppPrice(String productId) {
    final baseEnv = GetIt.I.get<BaseEnv>();
    for (final value in baseEnv.skus) {
      if (value.id == productId) {
        return value.subtitle;
      }
    }
    return "";
  }

  LocalTransactionModel createInitialLocalTransactionModel({
    required TransactionTypeEnum transactionTypeEnum,
    required String transactionData,
    required String transactionCurrency,
    required String transactionPrice,
    required String transactionDescription,
  }) {
    final LocalTransactionModel txManager = LocalTransactionModel(
        transactionType: transactionTypeEnum.name,
        transactionData: transactionData,
        transactionCurrency: transactionCurrency,
        transactionPrice: transactionPrice,
        transactionDescription: transactionDescription,
        transactionHash: "",
        dateTime: DateTime.now().millisecondsSinceEpoch,
        status: TransactionStatus.Undefined.name);
    return txManager;
  }

  Future handlerPurchaseEvent(PurchaseDetails purchaseDetails) async {
    final wallet = sl<AccountProvider>().accountPublicInfo;
    final navigator = Navigator.of(navigatorKey.currentState!.overlay!.context);

    if (wallet == null) {
      return;
    }

    try {
      final loading = Loading();
      loading.showLoading();

      final walletStore = GetIt.I.get<WalletsStore>();
      if (Platform.isIOS) {
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
        if (purchaseDetails is AppStorePurchaseDetails) {
          final creator = wallet.publicAddress;

          final AppleInAppPurchaseModel appleInAppPurchaseModel = AppleInAppPurchaseModel(
            productID: purchaseDetails.productID,
            purchaseID: purchaseDetails.purchaseID ?? '',
            receiptData: purchaseDetails.verificationData.localVerificationData,
            creator: creator,
          );

          final appleInAppPurchaseResponse = await walletStore.sendAppleInAppPurchaseCoinsRequest(
            appleInAppPurchaseModel,
          );
          loading.dismiss();
          if (appleInAppPurchaseResponse.isLeft()) {
            appleInAppPurchaseResponse.getLeft().message.show();
            return;
          }

          GetIt.I.get<HomeProvider>().buildAssetsList();
          LocaleKeys.purchase_successful.tr().show();
        }

        return;
      }

      if (purchaseDetails is GooglePlayPurchaseDetails) {
        final creator = wallet.publicAddress;

        final GoogleInAppPurchaseModel googleInAppPurchaseModel = GoogleInAppPurchaseModel(
          productID: purchaseDetails.productID,
          purchaseToken: purchaseDetails.verificationData.serverVerificationData,
          receiptData: jsonDecode(purchaseDetails.verificationData.localVerificationData) as Map,
          signature: purchaseDetails.billingClientPurchase.signature,
          creator: creator,
        );

        final googleInAppPurchase = await walletStore.sendGoogleInAppPurchaseCoinsRequest(googleInAppPurchaseModel);

        if (googleInAppPurchase.isLeft()) {
          loading.dismiss();
          googleInAppPurchase.getLeft().message.show();
          await Future.delayed(const Duration(seconds: 2));
          navigator.pushNamed(Routes.transactionFailure.name);
          return;
        }

        loading.dismiss();

        GetIt.I.get<HomeProvider>().buildAssetsList();
        LocaleKeys.purchase_successful.tr().show();
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    } catch (e) {
      log("Main Catch $e");
    }
  }

  Future setUpNotifications() async {
    final remoteNotificationService = sl<RemoteNotificationsProvider>();

    await remoteNotificationService.getNotificationsPermission();

    remoteNotificationService.listenToForegroundNotification();
  }

  Future<void> checkInternetConnectivity() async {
    final repository = GetIt.I.get<Repository>();

    if (!await repository.isInternetConnected()) {
      noInternet.showNoInternet();
    }

    repository.getInternetStatus().listen((event) {
      if (_appState != AppLifecycleState.resumed) return;
      if (event == InternetConnectionStatus.connected && noInternet.isShowing) {
        noInternet.dismiss();
      }

      if (event == InternetConnectionStatus.disconnected) {
        if (!noInternet.isShowing) {
          noInternet.showNoInternet();
        }
      }
    });
  }
}

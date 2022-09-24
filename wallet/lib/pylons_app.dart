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

//import for AppStoreProductDetails
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/components/no_internet.dart';
import 'package:pylons_wallet/components/pylons_app_theme.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view_view_model.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/widgets/pdf_viewer_full_screen.dart';
import 'package:pylons_wallet/pages/home/home.dart';
import 'package:pylons_wallet/pages/home/home_provider.dart';
import 'package:pylons_wallet/pages/home/message_screen/message_screen.dart';
import 'package:pylons_wallet/pages/home/wallet_screen/add_pylon_screen.dart';
import 'package:pylons_wallet/pages/home/wallet_screen/widgets/transaction_details.dart';
import 'package:pylons_wallet/pages/presenting_onboard_page/presenting_onboard_page.dart';
import 'package:pylons_wallet/pages/presenting_onboard_page/screens/create_wallet_screen.dart';
import 'package:pylons_wallet/pages/presenting_onboard_page/screens/restore_wallet_screen.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_screen.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_view_model.dart';
import 'package:pylons_wallet/pages/routing_page/routing_page.dart';
import 'package:pylons_wallet/pages/routing_page/update_app.dart';
import 'package:pylons_wallet/pages/settings/screens/general_screen/general_screen.dart';
import 'package:pylons_wallet/pages/settings/screens/general_screen/screens/payment_screen/payment_screen.dart';
import 'package:pylons_wallet/pages/settings/screens/general_screen/screens/payment_screen/screens/transaction_history.dart';
import 'package:pylons_wallet/pages/settings/screens/general_screen/screens/security_screen.dart';
import 'package:pylons_wallet/pages/settings/screens/legal_screen.dart';
import 'package:pylons_wallet/pages/settings/screens/recovery_screen/recovery_screen.dart';
import 'package:pylons_wallet/pages/settings/screens/recovery_screen/screens/practice_test.dart';
import 'package:pylons_wallet/pages/settings/screens/recovery_screen/screens/view_recovery_phrase.dart';
import 'package:pylons_wallet/pages/settings/settings_screen.dart';
import 'package:pylons_wallet/pages/settings/utils/user_info_provider.dart';
import 'package:pylons_wallet/services/data_stores/remote_data_store.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/remote_notifications_service.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:pylons_wallet/utils/route_util.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey();

final noInternet = NoInternetDialog();

class PylonsApp extends StatefulWidget {
  @override
  State<PylonsApp> createState() => _PylonsAppState();
}

class _PylonsAppState extends State<PylonsApp> {
  @override
  void initState() {
    super.initState();
    GetIt.I.get<Repository>().setApplicationDirectory();

    checkInternetConnectivity();
    setUpNotifications();
    InAppPurchase.instance.purchaseStream.listen(onEvent);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      builder: () => ChangeNotifierProvider.value(
          value: sl<UserInfoProvider>(),
          builder: (context, value) {
            return MaterialApp(
              // key: UniqueKey(),
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              title: "Pylons Wallet",
              theme: PylonsAppTheme().buildAppTheme(),
              initialRoute: '/',
              routes: {
                '/': (context) => const RoutingPage(),
                RouteUtil.ROUTE_HOME: (context) => const HomeScreen(),
                RouteUtil.ROUTE_APP_UPDATE: (context) => const UpdateApp(),
                RouteUtil.ROUTE_SETTINGS: (context) => const SettingScreen(),
                RouteUtil.ROUTE_LEGAL: (context) => const LegalScreen(),
                RouteUtil.ROUTE_RECOVERY: (context) => const RecoveryScreen(),
                RouteUtil.ROUTE_GENERAL: (context) => const GeneralScreen(),
                RouteUtil.ROUTE_SECURITY: (context) => const SecurityScreen(),
                RouteUtil.ROUTE_PAYMENT: (context) => const PaymentScreen(),
                RouteUtil.ROUTE_PRACTICE_TEST: (context) => const PracticeTest(),
                RouteUtil.ROUTE_VIEW_RECOVERY_PHRASE: (context) => const ViewRecoveryScreen(),
                RouteUtil.ROUTE_TRANSACTION_HISTORY: (context) => const TransactionHistoryScreen(),
                RouteUtil.ROUTE_ONBOARDING: (context) => const PresentingOnboardPage(),
                RouteUtil.ROUTE_CREATE_WALLET: (context) => const CreateWalletScreen(),
                RouteUtil.ROUTE_RESTORE_WALLET: (context) => const RestoreWalletScreen(),
                RouteUtil.ROUTE_ADD_PYLON: (context) => const AddPylonScreen(),
                RouteUtil.ROUTE_TRANSACTION_DETAIL: (context) => const TransactionDetailsScreen(),
                RouteUtil.ROUTE_MESSAGE: (context) => const MessagesScreen(),
                RouteUtil.ROUTE_PDF_FULL_SCREEN: (context) => const PdfViewerFullScreen(),
                RouteUtil.ROUTE_OWNER_VIEW: (context) {
                  if (ModalRoute.of(context) == null) {
                    return const SizedBox();
                  }

                  if (ModalRoute.of(context)?.settings.arguments == null) {
                    return const SizedBox();
                  }

                  if (ModalRoute.of(context)?.settings.arguments is NFT) {
                    final nft = ModalRoute.of(context)!.settings.arguments! as NFT;
                    final viewModel = sl<OwnerViewViewModel>();
                    viewModel.nft = nft;
                    return OwnerView(
                      ownerViewViewModel: viewModel,
                    );
                  }

                  return const SizedBox();
                },
                RouteUtil.ROUTE_PURCHASE_VIEW: (context) {
                  if (ModalRoute.of(context) == null) {
                    return const SizedBox();
                  }

                  if (ModalRoute.of(context)?.settings.arguments == null) {
                    return const SizedBox();
                  }

                  if (ModalRoute.of(context)?.settings.arguments is NFT) {
                    final nft = ModalRoute.of(context)!.settings.arguments! as NFT;
                    final viewModel = sl<PurchaseItemViewModel>();
                    viewModel.setNFT(nft);
                    return PurchaseItemScreen(
                      purchaseItemViewModel: viewModel,
                    );
                  }

                  return const SizedBox();
                },
              },
              builder: (context, widget) {
                ScreenUtil.setContext(context);

                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: widget ?? Container(),
                );
              },
            );
          }),
    );
  }

  Future<void> checkInternetConnectivity() async {
    final repository = GetIt.I.get<Repository>();

    if (!await repository.isInternetConnected()) {
      noInternet.showNoInternet();
    }

    repository.getInternetStatus().listen((event) {
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

  Future onEvent(List<PurchaseDetails> event) async {
    if (event.isEmpty) {
      return;
    }

    final loading = Loading();

    loading.showLoading();

    for (final purchaseDetails in event) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.purchased:
          await handlerPurchaseEvent(purchaseDetails);
          break;
        case PurchaseStatus.error:
          purchaseDetails.error?.message.show();
          break;
        case PurchaseStatus.restored:
          break;
        case PurchaseStatus.canceled:
          break;
      }
    }

    loading.dismiss();
  }

  Future handlerPurchaseEvent(PurchaseDetails purchaseDetails) async {
    try {
      final walletStore = GetIt.I.get<WalletsStore>();
      if (Platform.isIOS) {
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
        if (purchaseDetails is AppStorePurchaseDetails) {
          final creator = walletStore.getWallets().value.last.publicAddress;

          final AppleInAppPurchaseModel appleInAppPurchaseModel = AppleInAppPurchaseModel(
              productID: purchaseDetails.productID, purchaseID: purchaseDetails.purchaseID ?? '', receiptData: purchaseDetails.verificationData.localVerificationData, creator: creator);

          final appleInAppPurchaseResponse = await walletStore.sendAppleInAppPurchaseCoinsRequest(appleInAppPurchaseModel);

          if (appleInAppPurchaseResponse.isLeft()) {
            appleInAppPurchaseResponse.swap().toOption().toNullable()!.message.show();
            return;
          }

          GetIt.I.get<HomeProvider>().buildAssetsList();
          "purchase_successful".tr().show();
        }

        return;
      }

      if (purchaseDetails is GooglePlayPurchaseDetails) {
        final creator = walletStore.getWallets().value.last.publicAddress;

        final GoogleInAppPurchaseModel googleInAppPurchaseModel = GoogleInAppPurchaseModel(
            productID: purchaseDetails.productID,
            purchaseToken: purchaseDetails.verificationData.serverVerificationData,
            receiptData: jsonDecode(purchaseDetails.verificationData.localVerificationData) as Map,
            signature: purchaseDetails.billingClientPurchase.signature,
            creator: creator);

        final googleInAppPurchase = await walletStore.sendGoogleInAppPurchaseCoinsRequest(googleInAppPurchaseModel);

        if (googleInAppPurchase.isLeft()) {
          googleInAppPurchase.swap().toOption().toNullable()!.message.show();
          return;
        }

        GetIt.I.get<HomeProvider>().buildAssetsList();
        "purchase_successful".tr().show();
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    } catch (e) {
      log("Main Catch $e");
    }
  }

  Future setUpNotifications() async {
    final remoteNotificationService = sl<RemoteNotificationsService>();

    await remoteNotificationService.getNotificationsPermission();

    remoteNotificationService.listenToForegroundNotification();
  }
}

// ignore_for_file: cast_nullable_to_non_nullable

import 'package:flutter/material.dart';
import 'package:pylons_wallet/pages/settings/screens/general_screen/general_screen.dart';
import 'package:pylons_wallet/pages/settings/screens/recovery_screen/recovery_screen.dart';

import '../model/nft.dart';
import '../model/transaction_failure_model.dart';
import '../pages/detailed_asset_view/owner_view.dart';
import '../pages/detailed_asset_view/widgets/pdf_viewer_full_screen.dart';
import '../pages/home/home.dart';
import '../pages/home/message_screen/message_screen.dart';
import '../pages/home/wallet_screen/add_pylon_screen.dart';
import '../pages/home/wallet_screen/widgets/transaction_details.dart';
import '../pages/presenting_onboard_page/presenting_onboard_page.dart';
import '../pages/presenting_onboard_page/screens/accept_policy_screen.dart';
import '../pages/presenting_onboard_page/screens/create_wallet_screen.dart';
import '../pages/presenting_onboard_page/screens/restore_wallet_screen.dart';
import '../pages/purchase_item/purchase_item_screen.dart';
import '../pages/routing_page/splash_screen.dart';
import '../pages/routing_page/update_app.dart';
import '../pages/settings/screens/general_screen/screens/payment_screen/payment_screen.dart';
import '../pages/settings/screens/general_screen/screens/payment_screen/screens/transaction_history.dart';
import '../pages/settings/screens/general_screen/screens/security_screen.dart';
import '../pages/settings/screens/legal_screen.dart';
import '../pages/settings/screens/recovery_screen/screens/practice_test.dart';
import '../pages/settings/screens/recovery_screen/screens/view_recovery_phrase.dart';
import '../pages/settings/settings_screen.dart';
import '../pages/transaction_failure_manager/local_transaction_detail_screen.dart';
import '../pages/transaction_failure_manager/local_transactions_screen.dart';
import 'dependency_injection/dependency_injection.dart';

class RouteUtil {
  RouteUtil();
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final route = Routes.getAppRouteFromString(settings.name ?? "");
    switch (route) {
      case Routes.initial:
        return createRoute(const SplashScreen());
      case Routes.home:
        return createRoute(const HomeScreen());
      case Routes.appUpdate:
        return createRoute(const UpdateApp());
      case Routes.settings:
        return createRoute(const SettingScreen());
      case Routes.legal:
        return createRoute(const LegalScreen());
      case Routes.recovery:
        return createRoute(const RecoveryScreen());
      case Routes.general:
        return createRoute(const GeneralScreen());
      case Routes.security:
        return createRoute(const SecurityScreen());
      case Routes.payment:
        return createRoute(const PaymentScreen());
      case Routes.practiceTest:
        return createRoute(const PracticeTest());
      case Routes.viewRecoveryPhrase:
        return createRoute(const ViewRecoveryScreen());
      case Routes.onboarding:
        return createRoute(const PresentingOnboardPage());
      case Routes.createWallet:
        return createRoute(const CreateWalletScreen());
      case Routes.restoreWallet:
        return createRoute(const RestoreWalletScreen());
      case Routes.addPylon:
        return createRoute(const AddPylonScreen());
      case Routes.trasactionDetail:
        return createRoute(const TransactionDetailsScreen());
      case Routes.message:
        return createRoute(const MessagesScreen());
      case Routes.pdfFullScreen:
        return createRoute(const PdfViewerFullScreen());
      case Routes.transactionFailure:
        return createRoute(const LocalTransactionsScreen());
      case Routes.ownerView:
        if (settings.arguments != null && settings.arguments is NFT) {
          return createRoute(OwnerView(
            key: ValueKey(settings.arguments),
            nft: settings.arguments as NFT,
          ));
        }

        return createRoute(const SizedBox());
      case Routes.purchaseView:
        if (settings.arguments != null && settings.arguments is NFT) {
          return createRoute(PurchaseItemScreen(
            key: ValueKey(settings.arguments),
            nft: settings.arguments as NFT,
          ));
        }

        return createRoute(const SizedBox());
      case Routes.acceptPolicy:
        if (settings.arguments != null && settings.arguments is NFT) {
          return createRoute(AcceptPolicyScreen(
            nft: settings.arguments as NFT,
            viewModel: sl(),
          ));
        }

        return createRoute(const SizedBox());
      case Routes.localTransactionDetails:
        if (settings.arguments != null && settings.arguments is LocalTransactionModel) {
          return createRoute(LocalTransactionDetailScreen(
            localTransactionModel: settings.arguments as LocalTransactionModel,
          ));
        }
        break;
      case Routes.fallback:
        return createRoute(const SizedBox());
      case Routes.transactionHistory:
        return createRoute(const TransactionHistoryScreen());
      case Routes.eventView:
        return createRoute(const Placeholder());
    }

    return null;
  }

  static MaterialPageRoute createRoute(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }
}

enum Routes {
  initial,
  home,
  appUpdate,
  settings,
  legal,
  recovery,
  general,
  security,
  payment,
  practiceTest,
  viewRecoveryPhrase,
  onboarding,
  createWallet,
  restoreWallet,
  addPylon,
  trasactionDetail,
  message,
  pdfFullScreen,
  transactionFailure,
  localTransactionDetails,
  ownerView,
  purchaseView,
  transactionHistory,
  acceptPolicy,
  fallback,
  eventView;

  static Routes getAppRouteFromString(String routeName) {
    switch (routeName) {
      case '/':
        return initial;
      case 'home':
        return home;
      case 'appUpdate':
        return appUpdate;
      case 'settings':
        return settings;
      case 'legal':
        return legal;
      case 'recovery':
        return recovery;
      case 'general':
        return general;
      case 'security':
        return security;
      case 'payment':
        return payment;
      case 'practiceTest':
        return practiceTest;
      case 'viewRecoveryPhrase':
        return viewRecoveryPhrase;
      case 'onboarding':
        return onboarding;
      case 'createWallet':
        return createWallet;
      case 'restoreWallet':
        return restoreWallet;
      case 'addPylon':
        return addPylon;
      case 'trasactionDetail':
        return trasactionDetail;
      case 'message':
        return message;
      case 'pdfFullScreen':
        return pdfFullScreen;
      case 'transactionFailure':
        return transactionFailure;
      case 'ownerView':
        return ownerView;
      case 'purchaseView':
        return purchaseView;
      case 'acceptPolicy':
        return acceptPolicy;
      case 'localTransactionDetails':
        return localTransactionDetails;
      case 'transactionHistory':
        return transactionHistory;
      case 'eventView':
        return eventView;
      default:
        return fallback;
    }
  }
}

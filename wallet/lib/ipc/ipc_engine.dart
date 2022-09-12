import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/ipc/handler/handler_factory.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';
import 'package:pylons_wallet/ipc/models/sdk_ipc_response.dart';
import 'package:pylons_wallet/ipc/widgets/sdk_approval_dialog.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/pages/detailed_asset_view/owner_view.dart';
import 'package:pylons_wallet/pages/purchase_item/purchase_item_screen.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import 'package:transaction_signing_gateway/model/account_public_info.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Terminology
/// Signal : Incoming request from a 3rd party app
/// Key : The key is the process against which the 3rd part app has sent the signal
class IPCEngine {
  late StreamSubscription _sub;
  WalletsStore walletsStore;
  Repository repository;

  bool systemHandlingASignal = false;

  IPCEngine({required this.walletsStore, required this.repository});

  /// This method initiate the IPC Engine
  Future<bool> init() async {
    log('init', name: '[IPCEngine : init]');

    await handleInitialLink();
    setUpListener();
    return true;
  }

  /// This method setups the listener which receives
  void setUpListener() {
    _sub = linkStream.listen((String? link) async {
      if (link == null) {
        return;
      }

      final unwrappedLink = await checkAndUnWrapFirebaseLink(link);

      handleLinksBasedOnUri(unwrappedLink);

      // Link contains the data that the wallet need
    }, onError: (err) {});
  }

  /// This method is used to handle the uni link when the app first opens
  Future<void> handleInitialLink() async {
    /// This will handle the initial delay when the app first time opens
    await Future.delayed(const Duration(seconds: 2));

    final initialLink = await getInitialLink();

    final PendingDynamicLinkData? firebaseInitialLink = await FirebaseDynamicLinks.instance.getInitialLink();

    log('$firebaseInitialLink', name: '[IPCEngine : firebaseIntialLink]');
    if (firebaseInitialLink != null) {
      handleLinksBasedOnUri(firebaseInitialLink.link.toString());
      return;
    }

    log('$initialLink', name: '[IPCEngine : handleInitialLink]');
    if (initialLink != null && initialLink.isNotEmpty) {
      handleLinksBasedOnUri(initialLink);
      return;
    }
  }

  Future handleLinksBasedOnUri(String initialLink) async {
    if (_isEaselUniLink(initialLink)) {
      _handleEaselLink(initialLink);
    } else if (_isNFTViewUniLink(initialLink)) {
      _handleNFTViewLink(initialLink);
    } else if (_isNFTTradeUniLink(initialLink)) {
      _handleNFTTradeLink(initialLink);
    } else {
      handleLink(initialLink);
    }
  }

  /// This method encodes the message that we need to send to wallet
  /// Input]  [msg] is the string received from the wallet
  /// Output : [List] contains the decoded response
  String encodeMessage(List<String> msg) {
    final encodedMessageWithComma = msg.map((element) => base64Url.encode(utf8.encode(element))).join(',');
    return base64Url.encode(utf8.encode(encodedMessageWithComma));
  }

  /// This method decode the message that the wallet sends back
  /// Input : [msg] is the string received from the wallet
  /// Output : [List] contains the decoded response
  List<String> decodeMessage(String msg) {
    final decoded = utf8.decode(base64Url.decode(msg));
    return decoded.split(',').map((element) => utf8.decode(base64Url.decode(element))).toList();
  }

  /// This method handles the link that the wallet received from the 3rd Party apps
  /// Input : [link] contains the link that is received from the 3rd party apps.
  /// Output : [void] contains the decoded message
  Future<void> handleLink(String link) async {
    log(link, name: '[IPCEngine : handleLink]');

    final getMessage = link.split('/').last;

    SdkIpcMessage sdkIPCMessage;

    try {
      sdkIPCMessage = SdkIpcMessage.fromIpcMessage(getMessage);
    } catch (error) {
      return;
    }

    await showApprovalDialog(sdkIPCMessage: sdkIPCMessage);
  }

  Future<void> _handleEaselLink(String link) async {
    bool isHome = false;
    final currentWallets = walletsStore.getWallets().value;

    isHome = isHomeRoute();
    if (!repository.getBool(key: kIsUserCreatingAccount) && isHome == false) {
      navigatorKey.currentState!.popUntil(ModalRoute.withName(RouteUtil.ROUTE_HOME));
    }

    final queryParameters = Uri.parse(link).queryParameters;
    final recipeId = (queryParameters.containsKey(kRecipeIdKey)) ? queryParameters[kRecipeIdKey] ?? '' : "";
    final cookbookId = (queryParameters.containsKey(kCookbookIdKey)) ? queryParameters[kCookbookIdKey] ?? "" : "";
    final address = (queryParameters.containsKey(kAddress)) ? queryParameters[kAddress] ?? "" : "";

    if (currentWallets.isEmpty) {
      repository.saveInviteeAddressFromDynamicLink(dynamicLink: address);
      walletsStore.saveInitialLink(initialLink: link);
    }
    final nullableNFT = await getNFtFromRecipe(cookbookId: cookbookId, recipeId: recipeId);

    if (nullableNFT == null) {
      return;
    }
    repository.setBool(key: kIsUserCreatingAccount, value: false);

    if (isOwnerIsViewing(nullableNFT, currentWallets)) {
      await navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (_) => OwnerView(
            nft: nullableNFT,
            ownerViewViewModel: sl(),
          ),
          settings: RouteSettings(name: RouteUtil.ROUTE_OWNER_VIEW),
        ),
      );
    } else {
      await navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (_) => PurchaseItemScreen(
            nft: nullableNFT,
            purchaseItemViewModel: sl(),
          ),
          settings: RouteSettings(name: RouteUtil.ROUTE_PUCRCHASE_VIEW),
        ),
      );
    }

    walletsStore.setStateUpdatedFlag(flag: true);
  }

  bool isHomeRoute() {
    bool isHome = false;
    navigatorKey.currentState!.popUntil((route) {
      if (route.settings.name == RouteUtil.ROUTE_HOME) {
        isHome = true;
        return true;
      }
      isHome = false;
      return true;
    });
    return isHome;
  }

  bool isOwnerIsViewing(NFT nullableNFT, List<AccountPublicInfo> currentWallets) {
    if (currentWallets.isEmpty) return false;
    return nullableNFT.ownerAddress == currentWallets.last.publicAddress;
  }

  Future<void> _handleNFTTradeLink(String link) async {
    final queryParameters = Uri.parse(link).queryParameters;
    final tradeId = queryParameters.containsKey(kTradeIdKey) ? queryParameters[kTradeIdKey] ?? "" : "0";
    final address = queryParameters.containsKey(kAddress) ? queryParameters[kAddress] ?? "" : "";
    final currentWallets = walletsStore.getWallets().value;
    if (currentWallets.isEmpty) {
      "create_an_account_first".tr().show();
      repository.saveInviteeAddressFromDynamicLink(dynamicLink: address);
      walletsStore.saveInitialLink(initialLink: link);
      return;
    }

    final showLoader = Loading()..showLoading();

    final recipeResult = await walletsStore.getTradeByID(Int64.parseInt(tradeId));

    if (recipeResult == null) {
      "nft_does_not_exists".tr().show();
      showLoader.dismiss();
      return;
    }

    final item = await NFT.fromTrade(recipeResult);

    await item.getOwnerAddress();
    showLoader.dismiss();

    await navigatorKey.currentState!.push(
      MaterialPageRoute(
          builder: (_) => PurchaseItemScreen(
                nft: item,
                purchaseItemViewModel: sl(),
              ),
          settings: RouteSettings(name: RouteUtil.ROUTE_OWNER_VIEW)),
    );
    walletsStore.setStateUpdatedFlag(flag: true);
  }

  Future<void> _handleNFTViewLink(String link) async {
    final queryParameters = Uri.parse(link).queryParameters;
    final itemId = queryParameters['item_id'];
    final cookbookId = queryParameters['cookbook_id'];

    final showLoader = Loading()..showLoading();

    final recipeResult = await walletsStore.getItem(cookbookId!, itemId!);

    showLoader.dismiss();

    if (recipeResult == null) {
      ScaffoldMessenger.of(navigatorKey.currentState!.overlay!.context).showSnackBar(
        SnackBar(
          content: Text("nft_does_not_exists".tr()),
        ),
      );
    } else {
      final item = await NFT.fromItem(recipeResult);
      await navigatorKey.currentState!.push(
        MaterialPageRoute(
            builder: (_) => OwnerView(
                  nft: item,
                  ownerViewViewModel: sl(),
                ),
            settings: RouteSettings(name: RouteUtil.ROUTE_OWNER_VIEW)),
      );
      walletsStore.setStateUpdatedFlag(flag: true);
    }
  }

  /// This method sends the unilink to the wallet app
  /// Input : [String] is the unilink with data for the wallet app
  Future<bool> dispatchUniLink(String uniLink) async {
    try {
      if (Platform.isAndroid) {
        if (await canLaunchUrlString(uniLink)) {
          await launchUrlString(uniLink);
          return true;
        } else {
          return false;
        }
      } else {
        await launchUrlString(uniLink);
        return true;
      }
    } catch (error) {
      return true;
    }
  }

  /// This functions shows approval dialog to execute transactions as requested 3rd party apps.
  /// Input : [sdkIPCMessage] The sender of the signal
  Future showApprovalDialog({required SdkIpcMessage sdkIPCMessage}) async {
    if (sdkIPCMessage.action == HandlerFactory.GO_TO_PYLONS) {
      return;
    }

    final whiteListedTransactions = [
      HandlerFactory.GET_PROFILE,
      HandlerFactory.GET_COOKBOOK,
      HandlerFactory.TX_CREATE_COOKBOOK,
      HandlerFactory.TX_CREATE_RECIPE,
      HandlerFactory.SHOW_STRIPE,
      HandlerFactory.GET_RECIPES
    ];

    if (whiteListedTransactions.contains(sdkIPCMessage.action)) {
      await onUserApproval(sdkIPCMessage);
      return;
    }
    final repository = GetIt.I.get<Repository>();

    final biometricResponse = repository.getBiometricTransaction();

    if (shouldNotDoBiometric(biometricResponse)) {
      await showDialogForConfirmation(sdkIPCMessage);

      return;
    }

    final biometricAuthenticationResponse = await repository.authenticate();

    if (biometricAuthenticationResponse.getOrElse(() => false)) {
      await onUserApproval(sdkIPCMessage);
      return;
    }

    biometricAuthenticationResponse.swap().toOption().toNullable()!.message.show();
  }

  Future<void> showDialogForConfirmation(SdkIpcMessage sdkIPCMessage) async {
    final sdkApprovalDialog = SDKApprovalDialog(
        context: navigatorKey.currentState!.overlay!.context,
        sdkipcMessage: sdkIPCMessage,
        onApproved: () async {
          await onUserApproval(sdkIPCMessage);
        },
        onCancel: () async {
          await onUserCancelled(sdkIPCMessage);
        });

    await sdkApprovalDialog.show();
  }

  /// This method is called when the user cancels the transaction
  /// Input: [sdkIPCMessage] the transaction that the user cancels
  Future<void> onUserCancelled(SdkIpcMessage sdkIPCMessage) async {
    final cancelledResponse = SdkIpcResponse.failure(sender: sdkIPCMessage.sender, error: 'user_declined_request'.tr(), errorCode: HandlerFactory.ERR_USER_DECLINED);
    await checkAndDispatchUniLinkIfNeeded(handlerMessage: cancelledResponse, responseSendingNeeded: true);
  }

  /// This method is called when the user approves the transaction
  /// Input: [SdkIpcMessage] the transaction that the user approves.
  Future<void> onUserApproval(SdkIpcMessage sdkIPCMessage) async {
    final handlerMessage = await GetIt.I.get<HandlerFactory>().getHandler(sdkIPCMessage).handle();
    await checkAndDispatchUniLinkIfNeeded(handlerMessage: handlerMessage, responseSendingNeeded: sdkIPCMessage.requestResponse);
  }

  bool shouldNotDoBiometric(Either<Failure, bool> biometricResponse) => !biometricResponse.getOrElse(() => false);

  Future<void> checkAndDispatchUniLinkIfNeeded({required SdkIpcResponse handlerMessage, required bool responseSendingNeeded}) async {
    if (responseSendingNeeded) {
      await dispatchUniLink(handlerMessage.createMessageLink(isAndroid: Platform.isAndroid));
    }
  }

  /// This method disposes the
  void dispose() {
    _sub.cancel();
  }

  /// This method disconnect any new signal. If another signal is already in process
  /// Input : [sender] The sender of the signal
  /// Output : [key] The signal kind against which the signal is sent
  Future<void> disconnectThisSignal({required String sender, required String key}) async {
    final encodedMessage = encodeMessage([key, kIpcEncodeMessage]);
    await dispatchUniLink('pylons://$sender/$encodedMessage');
  }

  ///This method checks if the incoming link is generated from Easel
  bool _isEaselUniLink(String link) {
    final queryParam = Uri.parse(link).queryParameters;
    return queryParam.containsKey(kRecipeIdKey) && queryParam.containsKey(kCookbookIdKey);
  }

  bool _isNFTViewUniLink(String link) {
    final queryParam = Uri.parse(link).queryParameters;
    return queryParam.containsKey(kItemIdKey) && queryParam.containsKey(kCookbookIdKey);
  }

  bool _isNFTTradeUniLink(String link) {
    final queryParam = Uri.parse(link).queryParameters;
    return queryParam.containsKey(kTradeIdKey);
  }

  Future<String> checkAndUnWrapFirebaseLink(String link) async {
    if (!link.contains(kFirebaseLink)) {
      return link;
    }

    final uri = Uri.parse(link);

    if (uri.queryParameters.containsKey([kLinkKey])) {
      return uri.queryParameters[kLinkKey] ?? '';
    }

    final pendingDynamicLink = await FirebaseDynamicLinks.instance.getDynamicLink(Uri.parse(link));

    return pendingDynamicLink?.link.toString() ?? "";
  }

  /// This method get the NFT based on the cookbookId and the recipeId
  /// Input : [cookbookId] the id of the cookbook, [recipeId] the id of the recipe
  /// Output: returns [NFT] if successful otherwise returns [null]
  Future<NFT?> getNFtFromRecipe({required String cookbookId, required String recipeId}) async {
    final walletsStore = GetIt.I.get<WalletsStore>();

    final showLoader = Loading()..showLoading();

    final recipeResult = await walletsStore.getRecipe(cookbookId, recipeId);

    showLoader.dismiss();

    if (recipeResult.isLeft()) {
      "nft_does_not_exists".tr().show();
      return null;
    }

    final nft = NFT.fromRecipe(recipeResult.toOption().toNullable()!);

    await nft.getOwnerAddress();

    return nft;
  }
}

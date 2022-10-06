import 'package:dartz/dartz.dart' as dz;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/model/balance.dart';
import 'package:pylons_wallet/model/notification_message.dart';
import 'package:pylons_wallet/model/transaction.dart';
import 'package:pylons_wallet/pages/home/collection_screen/collection_screen.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/home/wallet_screen/model/currency.dart';
import 'package:pylons_wallet/pages/home/wallet_screen/wallet_screen.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/extension.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';

class HomeProvider extends ChangeNotifier {
  final Repository repository;
  final WalletsStore walletStore;

  HomeProvider({required this.repository, required this.walletStore});

  final List<Widget> pages = <Widget>[const CollectionScreen(), const WalletScreen()];
  final tabs = ['collection', 'wallet'];

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  int _newIndex = 0;

  int get newIndex => _newIndex;

  List<Balance> _balances = [];

  List<Balance> get balances => _balances;

  List<Currency> _items = [];

  List<Currency> get items => _items;

  List<TransactionHistory> _transactionHistoryList = [];

  List<TransactionHistory> get transactionHistoryList => _transactionHistoryList;

  set transactionHistoryList(List<TransactionHistory> txList) {
    _transactionHistoryList = txList;
    notifyListeners();
  }

  final int _limit = 10;
  final int _offset = 0;

  bool _showBadge = false;

  bool get showBadge => _showBadge;

  set showBadge(bool showBadge) {
    _showBadge = showBadge;
    notifyListeners();
  }

  Future<List<NotificationMessage>> callGetNotificationApi() async {
    final response = await repository.getAllNotificationsMessages(
      walletAddress: getWalletStore().getWallets().value.last.publicAddress,
      limit: _limit,
      offset: _offset,
    );
    if (response.isLeft()) {
      "something_wrong".tr().show();
      return [];
    }
    return response.getOrElse(() => []);
  }

  final notificationMessageObject = NotificationMessage(
    id: "",
    txHash: "",
    amount: 0,
    coin: "",
    createdAt: DateTime.now().millisecondsSinceEpoch,
    from: "",
    itemFormat: "",
    itemImg: "",
    itemName: "",
    read: true,
    settled: false,
    to: "",
    type: "",
    updatedAt: DateTime.now().millisecondsSinceEpoch,
  );

  Future<void> shouldShowBadgeOrNot() async {
    final notificationsList = await callGetNotificationApi();

    if (notificationsList.isEmpty) {
      showBadge = false;
      return;
    }
    showBadge = !notificationsList.firstWhere((element) => !element.read, orElse: () => notificationMessageObject).read;
  }

  Future<void> getTransactionHistoryList() async {
    final walletInfo = walletStore.getWallets().value.last;

    GetIt.I.get<Repository>().getTransactionHistory(address: walletInfo.publicAddress).then((value) {
      if (value.isRight()) {
        transactionHistoryList = value.getOrElse(() => []);
      }
    });
  }

  List<TransactionHistory> getDenomSpecificTxList({required String defaultCurrency}) {
    return transactionHistoryList.where((element) => element.amount.contains(defaultCurrency)).toList().take(3).toList();
  }

  void changeTabs(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  bool isBannerDark() {
    final value = repository.getIsBannerDark();

    if (value.isLeft()) {
      return true;
    }
    return value.getOrElse(() => true);
  }

  void setBalances(List<Balance> balances) {
    _balances = balances;
    notifyListeners();
  }

  void newOrder(int index) {
    _newIndex = index;
    notifyListeners();
  }

  void mapBalanceToCurrencyCard() {
    _items = _balances.map((coinModel) {
      String amount = coinModel.amount.toString();

      switch (coinModel.denom.toIBCCoinsEnum()) {
        case IBCCoins.upylon:
          amount = (double.parse(amount) / kBigIntBase).toString().truncateAfterDecimal(2);
          break;
        case IBCCoins.urun:
        case IBCCoins.ujunox:
        case IBCCoins.none:
        case IBCCoins.ujuno:
        case IBCCoins.ustripeusd:
        case IBCCoins.eeur:
        case IBCCoins.uatom:
          amount = (double.parse(coinModel.amount.toString()) / kBigIntBase).toString();
          break;
        case IBCCoins.weth_wei:
          amount = (double.parse(coinModel.amount.toString()) / kEthIntBase).toString();
          break;
      }

      return Currency(
          isDefault: _balances.indexOf(coinModel) == 0,
          abbrev: coinModel.denom.substring(kDenomInitial, kDenomFinal),
          currency: coinModel.denom.substring(1),
          asset: coinModel.denom.substring(1),
          amount: amount,
          ibcCoins: coinModel.denom.toIBCCoinsEnum());
    }).toList();
    notifyListeners();
  }

  void refresh() {
    notifyListeners();
  }

  int _getDenomPriority(String denom) {
    switch (denom) {
      case kPylonDenom:
        return 999;
      case kUSDDenom:
        return 998;
      default:
        return -999;
    }
  }

  Future<void> buildAssetsList() async {
    balances.clear();
    final currentWallet = getWalletStore().getWallets().value.last;

    final response = await getRepository().getBalance(currentWallet.publicAddress);

    if (response.isLeft()) {
      handleError(response);
      return;
    }
    setBalances(response.getOrElse(() => []).toSet().toList());

    balances.sort((a, b) {
      return _getDenomPriority(b.denom).compareTo(_getDenomPriority(a.denom));
    });

    mapBalanceToCurrencyCard();
  }

  void handleError(dz.Either<Failure, dynamic> either) {
    either.fold((l) {
      l.checkAndTakeAction(onError: (error) {});
    }, (r) => null);
  }

  void logAnalyticsEvent() {
    repository.logUserJourney(screenName: AnalyticsScreenEvents.home);
  }

  WalletsStore getWalletStore() {
    return walletStore;
  }

  Repository getRepository() {
    return repository;
  }

  void refreshScreen() {
    notifyListeners();
  }
}

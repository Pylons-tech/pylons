import 'package:cosmos_ui_components/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/model/transaction.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/settings/screens/general_screen/screens/payment_screen/widgets/transaction_card.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/extension.dart';

class TransactionsListView extends StatelessWidget {
  final List<TransactionHistory> transactionsHistoryList;

  const TransactionsListView({Key? key, required this.transactionsHistoryList})
      : super(key: key);

  bool isDateSame({required int index}) {
    if (index == 0) return false;
    return formatDate(
            DateTime.fromMillisecondsSinceEpoch(
                transactionsHistoryList[index].createdAt),
            DateFormatEnum.shortUIDateDay) ==
        formatDate(
            DateTime.fromMillisecondsSinceEpoch(
                transactionsHistoryList[index - 1].createdAt),
            DateFormatEnum.shortUIDateDay);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: transactionsHistoryList.length,
        itemBuilder: (context, index) {
          final transactionHistory = transactionsHistoryList[index];
          final coin = transactionHistory.ibcCoin;
          return TransactionCard(
            transactionType: transactionHistory.transactionType,
            denomText: coin.getAbbrev(),
            amountText: coin.getCoinWithProperDenomination(
                transactionHistory.amount.splitNumberAndAlpha()[0]),
            date: DateTime.fromMillisecondsSinceEpoch(
                transactionHistory.createdAt * kTimeStampInt),
            transactionTypeEnum: transactionHistory.transactionTypeEnum,
            isDateSame: isDateSame(index: index),
          );
        });
  }
}

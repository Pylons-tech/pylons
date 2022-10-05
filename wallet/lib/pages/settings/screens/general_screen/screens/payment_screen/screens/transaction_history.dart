import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/model/transaction.dart';
import 'package:pylons_wallet/pages/settings/screens/general_screen/screens/payment_screen/widgets/transactions_list_view.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';

TextStyle kTransactionHistoryLabelText = TextStyle(fontSize: 20.sp, fontFamily: kUniversalFontFamily, color: Colors.black, fontWeight: FontWeight.w800);
TextStyle kTransactionHistoryOptionsText = TextStyle(fontSize: 18.sp, fontFamily: kUniversalFontFamily, color: Colors.black, fontWeight: FontWeight.w600);

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  List<TransactionHistory> transactionsHistoryList = [];
  Repository get repository => GetIt.I.get();

  @override
  void initState() {
    super.initState();

    final walletInfo = GetIt.I.get<WalletsStore>().getWallets().value.last;

    repository.getTransactionHistory(address: walletInfo.publicAddress).then((value) {
      if (value.isRight()) {
        transactionsHistoryList = value.getOrElse(() => []);
        transactionsHistoryList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      }

      setState(() {});
    });

    repository.logUserJourney(screenName: AnalyticsScreenEvents.transactionHistory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.of(context).viewPadding.top,
            ),
            SizedBox(height: 25.h),
            Align(
              alignment: Alignment.centerLeft,
              child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.kUserInputTextColor,
                  )),
            ),
            SizedBox(
              height: 25.h,
            ),
            Text(
              "transaction_history".tr(),
              style: kTransactionHistoryLabelText.copyWith(fontSize: 20.sp),
            ),
            SizedBox(
              height: 20.h,
            ),
            Expanded(child: TransactionsListView(transactionsHistoryList: transactionsHistoryList)),
          ],
        ),
      ),
    );
  }
}

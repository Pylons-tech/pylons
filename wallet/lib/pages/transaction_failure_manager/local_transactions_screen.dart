import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/model/transaction_failure_model.dart';
import 'package:pylons_wallet/pages/home/wallet_screen/widgets/latest_transactions.dart';
import 'package:pylons_wallet/pages/transaction_failure_manager/failure_manager_view_model.dart';
import 'package:pylons_wallet/pages/transaction_failure_manager/widgets/my_list_tile.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/extension.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

class LocalTransactionsScreen extends StatefulWidget {
  const LocalTransactionsScreen({Key? key}) : super(key: key);

  @override
  State<LocalTransactionsScreen> createState() => _LocalTransactionsScreenState();
}

class _LocalTransactionsScreenState extends State<LocalTransactionsScreen> {
  FailureManagerViewModel get failureManagerViewModel => sl();
  Repository get repository => sl();

  @override
  void initState() {
    failureManagerViewModel.getAllFailuresFromDB();
    super.initState();
    repository.logUserJourney(screenName: AnalyticsScreenEvents.localTransactionHistory);
  }

  Widget getTransactionStatusButton({required LocalTransactionModel txManager}) {
    final TransactionStatus txStatusEnum = txManager.status.toTransactionStatusEnum();
    switch (txStatusEnum) {
      case TransactionStatus.Success:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(SVGUtil.TRANSACTION_SUCCESS, height: 15.h),
          ],
        );
      case TransactionStatus.Failed:
        return SvgPicture.asset(SVGUtil.TRANSACTION_FAILED, height: 15.h);
      case TransactionStatus.Undefined:
        return const Icon(Icons.error_outline, color: Colors.redAccent);
    }
  }

  Widget getMyDateStamp({required int txTime}) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(txTime);
    return Padding(
      padding: EdgeInsets.all(5.h),
      child: Text("${monthStrMap[date.month]!} ${date.day.toString()}",
          style: TextStyle(
            color: AppColors.kDarkGrey,
            fontSize: 12.sp,
          )),
    );
  }

  Widget getTransactionTitle({required LocalTransactionModel txModel}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: isTablet ? 5 : 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Text(
              isTablet ? txModel.transactionDescription : txModel.transactionDescription.trimStringMedium(stringTrimConstantMid),
              style: TextStyle(
                color: AppColors.kBlack,
                fontFamily: kUniversalFontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 12.sp,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (txModel.status.toTransactionStatusEnum() == TransactionStatus.Failed)
          InkWell(
            onTap: () => failureManagerViewModel.handleRetry(txManager: txModel),
            child: SvgPicture.asset(SVGUtil.TRANSACTION_RETRY, height: 12.h),
          ),
        const Spacer(),
        SizedBox(width: isTablet ? null : 35.w, child: getTransactionStatusButton(txManager: txModel)),
      ],
    );
  }

  String getFormattedPrice(LocalTransactionModel txModel) {
    if (txModel.transactionPrice == "0") {
      return "free".tr();
    }
    return "${txModel.transactionPrice}  ${txModel.transactionCurrency}";
  }

  Widget getTransactionTrailings({required LocalTransactionModel txModel}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(getFormattedPrice(txModel),
            style: TextStyle(
              color: AppColors.kBlack,
              fontFamily: kUniversalFontFamily,
              fontWeight: FontWeight.w800,
              fontSize: txModel.transactionPrice == "0" ? 13.sp : 11.sp,
            )),
        Icon(Icons.keyboard_arrow_right_rounded, size: 20.r)
      ],
    );
  }

  Widget getEmptyListWidget() {
    return const Center(
      child: Text(
        "No Failures!!",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 60.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkResponse(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Icon(
                      Icons.arrow_back_ios_sharp,
                      size: 25.r,
                    ),
                  )),
              Text(
                'all_transactions'.tr(),
                style: TextStyle(color: AppColors.kBlack, fontFamily: kUniversalFontFamily, fontWeight: FontWeight.bold, fontSize: 20.sp),
              ),
              SizedBox(width: 40.w),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 10.w), child: buildScreenContent(value: failureManagerViewModel)),
        ],
      ),
    ));
  }

  Widget buildScreenContent({required FailureManagerViewModel value}) {
    return ChangeNotifierProvider<FailureManagerViewModel>.value(
      value: value,
      builder: (context, child) {
        return Consumer(
          builder: (context, FailureManagerViewModel failureVM, child) {
            if (failureVM.localTransactionsList.isEmpty) {
              return getEmptyListWidget();
            }
            return ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: failureVM.localTransactionsList.length,
                itemBuilder: (context, int index) {
                  final LocalTransactionModel txManager = failureVM.localTransactionsList[index];
                  return MyListTile(
                    leadingWidget: (context) => getMyDateStamp(txTime: txManager.dateTime),
                    titleWidget: (context) => getTransactionTitle(txModel: txManager),
                    trailingWidget: (context) => getTransactionTrailings(txModel: txManager),
                    txModel: txManager,
                  );
                });
          },
        );
      },
    );
  }
}

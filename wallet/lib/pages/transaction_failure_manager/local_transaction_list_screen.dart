import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/model/transaction_failure_model.dart';
import 'package:pylons_wallet/pages/home/wallet_screen/widgets/latest_transactions.dart';
import 'package:pylons_wallet/pages/transaction_failure_manager/failure_manager_view_model.dart';
import 'package:pylons_wallet/pages/transaction_failure_manager/widgets/my_list_tile.dart';
import 'package:pylons_wallet/utils/dependency_injection/dependency_injection.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/extension.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

class FailureListScreen extends StatefulWidget {
  const FailureListScreen({Key? key}) : super(key: key);

  @override
  State<FailureListScreen> createState() => _FailureListScreenState();
}

class _FailureListScreenState extends State<FailureListScreen> {
  FailureManagerViewModel get failureManagerViewModel => sl();

  @override
  void initState() {
    failureManagerViewModel.getAllFailuresFromDB();
    super.initState();
  }

  Widget getTransactionStatusButton({required LocalTransactionModel txManager}) {
    final TransactionStatus txStatusEnum = txManager.status.toTransactionStatusEnum();
    switch (txStatusEnum) {
      case TransactionStatus.Success:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                await failureManagerViewModel.deleteFailure(id: txManager.id!);
              },
              child: SvgPicture.asset(
                SVGUtil.TRANSACTION_SUCCESS,
                height: 15.h,
              ),
            ),
          ],
        );
      case TransactionStatus.Failed:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => failureManagerViewModel.handleRetry(txManager: txManager),
              child: SvgPicture.asset(SVGUtil.TRANSACTION_RETRY, height: 12.h),
            ),
            InkWell(
              onTap: () => failureManagerViewModel.deleteFailure(id: txManager.id!),
              child: SvgPicture.asset(SVGUtil.TRANSACTION_FAILED, height: 15.h),
            ),
          ],
        );
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
            color: kDarkGrey,
            fontSize: 12.sp,
          )),
    );
  }

  Widget getTransactionTitle({required LocalTransactionModel txModel}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(txModel.transactionDescription.trimStringShort(stringTrimConstantMid),
              style: TextStyle(
                color: kBlack,
                fontFamily: kUniversalFontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 13.sp,
              )),
        ),
        const Spacer(),
        SizedBox(width: 40.w, child: getTransactionStatusButton(txManager: txModel)),
      ],
    );
  }

  Widget getTransactionTrailings({required LocalTransactionModel txModel}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("20 USD",
            style: TextStyle(
              color: kBlack,
              fontFamily: kUniversalFontFamily,
              fontWeight: FontWeight.w800,
              fontSize: 10.sp,
            )),
        Icon(Icons.keyboard_arrow_right_rounded, size: 22.r)
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
              IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_sharp, size: 25.r)),
              Text(
                'all_transactions'.tr(),
                style: TextStyle(color: kBlack, fontFamily: kUniversalFontFamily, fontWeight: FontWeight.bold, fontSize: 20.sp),
              ),
              SizedBox(width: 40.w),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: ChangeNotifierProvider<FailureManagerViewModel>.value(
              value: failureManagerViewModel,
              builder: (context, child) {
                return Consumer(
                  builder: (context, FailureManagerViewModel failureVM, child) {
                    if (failureVM.localTransactionsList.isEmpty) {
                      return getEmptyListWidget();
                    }
                    return ListView.separated(
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        shrinkWrap: true,
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
            ),
          ),
        ],
      ),
    ));
  }
}

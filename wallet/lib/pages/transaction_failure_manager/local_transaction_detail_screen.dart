import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/main_prod.dart';
import 'package:pylons_wallet/model/transaction_failure_model.dart';
import 'package:pylons_wallet/pages/home/wallet_screen/widgets/view_in_collection_button.dart';
import 'package:pylons_wallet/pages/transaction_failure_manager/failure_manager_view_model.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/extension.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

TextStyle _titleTextStyle = TextStyle(color: AppColors.kBlack, fontFamily: kUniversalFontFamily, fontWeight: FontWeight.bold, fontSize: 20.sp);

class LocalTransactionDetailScreen extends StatefulWidget {
  const LocalTransactionDetailScreen({Key? key}) : super(key: key);

  @override
  State<LocalTransactionDetailScreen> createState() => _LocalTransactionDetailScreenState();
}

class _LocalTransactionDetailScreenState extends State<LocalTransactionDetailScreen> {
  Repository get repository => GetIt.I.get();

  @override
  void initState() {
    super.initState();

    repository.logUserJourney(screenName: AnalyticsScreenEvents.localTransactionHistoryDetail);
  }

  bool getTxTypeFlag({required TransactionStatus txType}) {
    switch (txType) {
      case TransactionStatus.Success:
        return true;
      case TransactionStatus.Failed:
        return false;
      case TransactionStatus.Undefined:
        return false;
    }
  }

  Widget buildErrorHeader({required TransactionStatus status}) {
    switch (status) {
      case TransactionStatus.Success:
        return const SizedBox();
      case TransactionStatus.Failed:
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            height: 90.h,
            color: AppColors.kDarkRed,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Center(
                child: AutoSizeText("network_error_description".tr(), maxLines: 3, textAlign: TextAlign.justify, style: _titleTextStyle.copyWith(color: AppColors.kWhite, fontSize: 13.sp)),
              ),
            ),
          ),
        );
      case TransactionStatus.Undefined:
        return const SizedBox();
    }
  }

  String getFormattedPrice(LocalTransactionModel txModel) {
    if (txModel.transactionPrice == "0") {
      return "free".tr();
    }
    return "${txModel.transactionPrice}  ${txModel.transactionCurrency}";
  }

  Widget buildNFTDetailHeader({required LocalTransactionModel args}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
      child: SizedBox(
        height: 70.h,
        child: Row(
          children: [
            SizedBox(height: 70.h, width: 70.h, child: SvgPicture.asset(SVGUtil.PYLONS_POINTS_ICON)),
            SizedBox(width: 10.w),
            Expanded(
              flex: isTablet ? 7 : 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("purchased".tr(), style: _titleTextStyle.copyWith(fontSize: 15.sp)),
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          args.transactionDescription,
                          style: _titleTextStyle.copyWith(
                            fontSize: 11.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Expanded(
              child: AutoSizeText(
                getFormattedPrice(args),
                style: TextStyle(
                    color: getTxTypeFlag(txType: args.status.toTransactionStatusEnum()) ? AppColors.kDarkGreen : AppColors.kDarkRed,
                    fontFamily: kUniversalFontFamily,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            )
          ],
        ),
      ),
    );
  }

  Map<String, String> transactionDetailBodyMap({required LocalTransactionModel txArgs}) {
    if (txArgs.status.toTransactionStatusEnum() == TransactionStatus.Success && txArgs.transactionHash.isNotEmpty) {
      return {
        "txId".tr(): txArgs.transactionHash,
        "transaction_date".tr(): DateFormat('MMM dd, yyyy').format(DateTime.fromMillisecondsSinceEpoch(txArgs.dateTime)),
        "transaction_time".tr(): "${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(txArgs.dateTime).toUtc())} UTC",
        "currency".tr(): txArgs.transactionCurrency,
        "price".tr(): txArgs.transactionPrice,
      };
    }

    return {
      "transaction_date".tr(): DateFormat('MMM dd, yyyy').format(DateTime.fromMillisecondsSinceEpoch(txArgs.dateTime)),
      "transaction_time".tr(): "${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(txArgs.dateTime).toUtc())} UTC",
      "currency".tr(): txArgs.transactionCurrency,
      "price".tr(): txArgs.transactionPrice,
    };
  }

  Padding buildTxDetailBody({required LocalTransactionModel txArgs}) {
    final txDetailMap = transactionDetailBodyMap(txArgs: txArgs);
    final detailList = txDetailMap.entries.map((element) => buildRow(key: element.key, value: element.value)).toList();
    return Padding(padding: EdgeInsets.symmetric(horizontal: 30.h), child: Column(children: detailList));
  }

  Row buildRow({required String key, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(key, style: _titleTextStyle.copyWith(fontSize: 13.sp, fontWeight: FontWeight.w600)),
        SizedBox(height: 20.h),
        Text(value.trimString(stringTrimConstantMax), style: _titleTextStyle.copyWith(fontSize: 13.sp, fontWeight: FontWeight.bold, color: AppColors.kBlack)),
      ],
    );
  }

  FailureManagerViewModel get failureManagerViewModel => GetIt.I.get();

  Widget buildPageFooterButtons({required LocalTransactionModel txModel}) {
    switch (txModel.status.toTransactionStatusEnum()) {
      case TransactionStatus.Success:
        return Positioned(
          bottom: 15.h,
          left: 20.w,
          right: 20.w,
          child: TextButton(
              onPressed: () => Navigator.pop(navigatorKey.currentState!.overlay!.context),
              child: Text(
                "close".tr(),
                style: _titleTextStyle.copyWith(fontSize: 15.sp, color: AppColors.kGreyColor),
              )),
        );
      case TransactionStatus.Failed:
        return Stack(
          children: [
            Positioned(
              bottom: 50.h,
              left: 20.w,
              right: 20.w,
              child: BlueClippedButton(
                onTap: () async {
                  Navigator.pop(navigatorKey.currentState!.overlay!.context);
                  final showLoading = Loading()..showLoading();
                  await failureManagerViewModel.handleRetry(txManager: txModel);
                  showLoading.dismiss();
                },
                text: "retry".tr(),
              ),
            ),
            Positioned(
              bottom: 10.h,
              left: 20.w,
              right: 20.w,
              child: TextButton(
                onPressed: () => Navigator.pop(navigatorKey.currentState!.overlay!.context),
                child: Text(
                  "close".tr(),
                  style: _titleTextStyle.copyWith(fontSize: 15.sp, color: AppColors.kGreyColor),
                ),
              ),
            ),
          ],
        );
      case TransactionStatus.Undefined:
        return Positioned(
          bottom: 15.h,
          left: 20.w,
          right: 20.w,
          child: TextButton(
              onPressed: () => Navigator.pop(navigatorKey.currentState!.overlay!.context),
              child: Text(
                "close".tr(),
                style: _titleTextStyle.copyWith(fontSize: 15.sp, color: AppColors.kGreyColor),
              )),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments! as LocalTransactionModel;
    return Scaffold(
      body: Stack(
        children: [
          Column(
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
                    'details'.tr(),
                    style: _titleTextStyle,
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              buildErrorHeader(status: args.status.toTransactionStatusEnum()),
              buildNFTDetailHeader(args: args),
              buildTxDetailBody(txArgs: args),
            ],
          ),
          buildPageFooterButtons(txModel: args),
        ],
      ),
    );
  }
}

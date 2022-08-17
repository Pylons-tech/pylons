import 'package:cosmos_ui_components/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pylons_wallet/model/transaction.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    required this.transactionType,
    required this.date,
    required this.amountText,
    required this.denomText,
    required this.transactionTypeEnum,
    required this.isDateSame,
    Key? key,
  }) : super(key: key);

  final String transactionType;
  final DateTime date;
  final String amountText;
  final String denomText;
  final TransactionType transactionTypeEnum;
  final bool isDateSame;

  bool isOutGoing() {
    switch (transactionTypeEnum) {
      case TransactionType.SEND:
        return false;
      case TransactionType.RECEIVE:
        return true;
      case TransactionType.NFTBUY:
        return false;
      case TransactionType.NFTSELL:
        return true;
    }
  }

  Widget getDateStamp({required DateTime date}) {
    if (isDateSame) {
      return SizedBox(width: 22.w);
    }

    final formattedDate = formatDate(date, DateFormatEnum.shortUIDateDay).split(" ");

    return SizedBox(
      width: 22.w,
      child: Column(
        children: [
          Text(
            formattedDate[0],
            style: kTransactionTitle.copyWith(fontSize: 13.sp, color: kGray),
          ),
          Text(
            formattedDate[1],
            style: kTransactionTitle.copyWith(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          getDateStamp(date: date),
          SizedBox(width: 10.w),
          LeadingBuilder(
            onSendReceive: (context) => SvgPicture.asset(SVGUtil.PAYMENT_SEND_RECEIVE),
            onBuySell: (context) => SvgPicture.asset(SVGUtil.PAYMENT_TAG),
            transactionType: transactionTypeEnum,
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(transactionType, style: kTransactionTitle.copyWith(fontSize: 16.sp)),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${!isOutGoing() ? '-' : '+'}${amountText.toUpperCase()}',
                style: kTransactionTitle.copyWith(color: !isOutGoing() ? kTransactionRed : kTransactionGreen, fontSize: 16.sp),
              ),
              Text(
                denomText.toUpperCase(),
                style: kTransactionTitle.copyWith(color: !isOutGoing() ? kTransactionRed : kTransactionGreen, fontSize: 12.sp),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class LeadingBuilder extends StatelessWidget {
  final WidgetBuilder onSendReceive;
  final WidgetBuilder onBuySell;
  final TransactionType transactionType;

  const LeadingBuilder({
    Key? key,
    required this.onSendReceive,
    required this.onBuySell,
    required this.transactionType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (transactionType) {
      case TransactionType.SEND:
        return onSendReceive(context);
      case TransactionType.RECEIVE:
        return onSendReceive(context);
      case TransactionType.NFTBUY:
        return onBuySell(context);
      case TransactionType.NFTSELL:
        return onBuySell(context);
    }
  }
}

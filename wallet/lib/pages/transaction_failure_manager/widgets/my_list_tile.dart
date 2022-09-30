import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pylons_wallet/model/transaction_failure_model.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/utils/route_util.dart';

class MyListTile extends StatelessWidget {
  final WidgetBuilder leadingWidget;
  final WidgetBuilder titleWidget;
  final WidgetBuilder trailingWidget;
  final LocalTransactionModel txModel;

  const MyListTile({
    Key? key,
    required this.leadingWidget,
    required this.titleWidget,
    required this.trailingWidget,
    required this.txModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(navigatorKey.currentState!.overlay!.context).pushNamed(RouteUtil.ROUTE_LOCAL_TRX_DETAILS, arguments: txModel);
      },
      child: SizedBox(
        height: 40.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 2, child: leadingWidget(context)),
            Flexible(flex: 6, child: titleWidget(context)),
            Flexible(flex: 3, child: trailingWidget(context)),
          ],
        ),
      ),
    );
  }
}

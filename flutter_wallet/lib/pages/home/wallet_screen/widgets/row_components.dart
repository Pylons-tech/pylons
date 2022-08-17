import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/pages/stripe_screen.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/services/third_party_services/stripe_handler.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

class RowComponents extends StatelessWidget {
  final VoidCallback onRefresh;

  const RowComponents({Key? key, required this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          GestureDetector(
            onTap: () {
              handleStripeAccountLink(context);
            },
            child: Image.asset(
              ImageUtil.PYLONS_STRIPE_BANNER,
              width: 40,
            ),
          ),

          SizedBox(
            width: 20.w,
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(RouteUtil.ROUTE_TRANSACTION_HISTORY),
            child: SvgPicture.asset(SVGUtil.WALLET_TRANSACTION_HISTORY),
          ),
          SizedBox(
            width: 20.w,
          ),
          GestureDetector(
            onTap: () {
              final publicAddress = GetIt.I.get<WalletsStore>().getWallets().value.last.publicAddress;

              Clipboard.setData(ClipboardData(text: publicAddress)).then(
                (_) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: const Text("copied_to_clipboard").tr()));
                },
              );
            },
            child: SvgPicture.asset(SVGUtil.WALLET_COPY),
          ),
          SizedBox(
            width: 10.w,
          ),
        ],
      ),
    );
  }


  Future<void> handleStripeAccountLink(BuildContext context) async {
    final loading = Loading()..showLoading();

    final account_response = await GetIt.I.get<StripeHandler>().handleStripeAccountLink();
    loading.dismiss();
    account_response.fold((fail) => {fail.message.show()}, (accountlink) {
      showDialog(
          useSafeArea: false,
          context: context,
          builder: (BuildContext context) {
            return StripeScreen(
                url: accountlink,
                onBack: () {
                  navigatorKey.currentState!.pop();
                });
          });
    });
  }
}

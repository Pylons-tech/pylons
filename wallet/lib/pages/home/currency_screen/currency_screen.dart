import 'dart:async';

import 'package:dartz/dartz.dart' as dz;
import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/model/amount.dart';
import 'package:pylons_wallet/model/balance.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/home/currency_screen/widgets/stripe_payout_widget.dart';
import 'package:pylons_wallet/pages/stripe_screen.dart';
import 'package:pylons_wallet/pylons_app.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/services/third_party_services/stripe_handler.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart' as constants;
import 'package:pylons_wallet/utils/extension.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:pylons_wallet/utils/formatter.dart';
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';
import 'package:sprintf/sprintf.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

Map<String, Color> denomColors = {'upylon': const Color(0xFF5252d5), 'ustripeusd': const Color(0xFF85bb65), 'uusd': const Color(0xFF85bb65)};

class _CurrencyScreenState extends State<CurrencyScreen> {
  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      _buildAssetsList();
    });
  }

  List<Balance> assets = <Balance>[];

  Future<void> handleStripePayout(String amount) async {
    navigatorKey.currentState!.pop();

    final loading = Loading()..showLoading();

    final payout_response = await GetIt.I.get<StripeHandler>().handleStripePayout(amount);
    loading.dismiss();
    payout_response.fold(
        (fail) => {fail.message.show()},
        (payout_transfer_id) => {
              sprintf("payout_request_success".tr(), [payout_transfer_id]).show()
            });

    await _buildAssetsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.content_copy_outlined,
              color: constants.kBlue,
            ),
            onPressed: () {
              copyClipboard();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.cached_outlined,
              color: constants.kBlue,
            ),
            onPressed: () {
              _buildAssetsList();
            },
          ),
          const SizedBox(width: 8) // hack - is there a better (more durable) way to align things within an appbar?
        ],
      ),
      body: ListView(
        children: [
          ...assets.map((asset) {
            if (asset.denom.toIBCCoinsEnum() != IBCCoins.none) {
              return BalanceIBCCoins(
                key: ValueKey(asset),
                balance: asset,
                ibcCoins: asset.denom.toIBCCoinsEnum(),
              );
            }

            return _BalanceWidget(
                balance: asset,
                onCallFaucet: () {},
                onCallStripePayout: () {
                  getPayout(context, asset.amount.value.toString());
                },
                backgroundColor: denomColors[asset.denom] ?? Colors.blueGrey);
          }).toList()
        ],
      ),
    );
  }

  int _getDenomPriority(String denom) {
    switch (denom) {
      case constants.kPylonDenom:
        return 999;
      case constants.kUSDDenom:
        return 998;
      default:
        return -999;
    }
  }

  Future<void> _buildAssetsList() async {
    assets.clear();

    final walletStore = GetIt.I.get<WalletsStore>().getWallets().value.last;

    final response = await GetIt.I.get<Repository>().getBalance(walletStore.publicAddress);

    if (response.isLeft()) {
      showErrorMessageToUser(response);
      return;
    }

    assets = response.getOrElse(() => []);
    assets.sort((a, b) {
      return _getDenomPriority(b.denom).compareTo(_getDenomPriority(a.denom));
    });

    if (mounted) {
      setState(() {});
    }
  }

  Future copyClipboard() async {
    final msg = GetIt.I.get<WalletsStore>().getWallets().value.last.publicAddress;
    Clipboard.setData(ClipboardData(text: msg)).then((_) {
      "wallet_copied".tr().show();
    });
  }

  Future getPayout(BuildContext context, String amount) async {
    StripePayoutWidget(context: context, amount: amount, onCallback: handleStripePayout).show();
  }

  void showErrorMessageToUser(dz.Either<Failure, List<Balance>> response) {
    if (!mounted) {
      return;
    }
    context.show(message: response.swap().toOption().toNullable()!.message);
  }
}

class _BalanceWidget extends StatefulWidget {
  const _BalanceWidget({Key? key, required this.balance, required this.onCallFaucet, required this.onCallStripePayout, required this.backgroundColor}) : super(key: key);

  final Balance balance;
  final Function onCallFaucet;
  final Function onCallStripePayout;
  final Color backgroundColor;

  @override
  State<_BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<_BalanceWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    final coinMeta = constants.kCoinDenom.keys.contains(widget.balance.denom)
        ? constants.kCoinDenom[widget.balance.denom]
        : {"name": widget.balance.denom, "icon": "", "denom": widget.balance.denom, "short": widget.balance.denom, "faucet": false};

    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        borderOnForeground: false,
        elevation: 20,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
          width: screenSize.width(),
          height: screenSize.width(percent: 0.35),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: widget.backgroundColor,
              image: DecorationImage(image: const AssetImage('assets/images/masks/card_luma.png'), fit: BoxFit.fill, colorFilter: ColorFilter.mode(widget.backgroundColor, BlendMode.overlay))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: [
                if (coinMeta["icon"] != "") ...[
                  if (coinMeta["icon"].toString().contains(".svg"))
                    SvgPicture.asset(coinMeta["icon"].toString(), width: 30, height: 30)
                  else
                    Image.asset(coinMeta["icon"].toString(), width: 30, height: 30),
                  const SizedBox(width: 10),
                ],
                Text(
                  "${coinMeta["name"]}",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white, fontSize: 18),
                ),
                const Spacer(),
                if (widget.balance.denom != constants.kUSDDenom)
                  ElevatedButton(
                      onPressed: () {
                        widget.onCallFaucet();
                      },
                      style: ElevatedButton.styleFrom(
                        maximumSize: const Size(100, 20), disabledForegroundColor: constants.kWhite.withOpacity(0.38), disabledBackgroundColor: constants.kWhite.withOpacity(0.12),
                        minimumSize: const Size(100, 20),
                      ),
                      child: Text("faucet".tr(), style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 12, fontFamily: 'Inter')))
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: GestureDetector(
                      onTap: () {
                        handleStripeAccountLink();
                      },
                      child: Image.asset(
                        ImageUtil.PYLONS_STRIPE_BANNER,
                        width: 40,
                      ),
                    ),
                  )
              ]),
              if (widget.balance.denom != constants.kUSDDenom)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "\$${_getMultiplier(widget.balance.denom)} = 1 ${coinMeta['short']}",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white, fontSize: 12, fontFamily: 'Inter'),
                  ),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "\$${"${widget.balance.amount.toHumanReadable() * _getMultiplier(widget.balance.denom)}".trimZero()}",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white, fontSize: 24, fontFamily: 'Inter'),
                ),
              ),
            ],
          ),
        ));
  }

  Decimal _getMultiplier(String denom) {
    switch (denom) {
      case constants.kUSDDenom:
        return Decimal.one;
      case constants.kPylonDenom:
        return Decimal.parse('0.01');
      default:
        return Decimal.zero; // TODO: implement CoinMarketCap api call
    }
  }

  Future<void> handleStripeAccountLink() async {
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

class BalanceIBCCoins extends StatefulWidget {
  final Balance balance;
  final IBCCoins ibcCoins;

  const BalanceIBCCoins({Key? key, required this.balance, required this.ibcCoins}) : super(key: key);

  @override
  _BalanceIBCCoinsState createState() => _BalanceIBCCoinsState();
}

class _BalanceIBCCoinsState extends State<BalanceIBCCoins> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        borderOnForeground: false,
        elevation: 20,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
          width: 1.sw,
          height: 0.35.sw,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: denomColors[widget.balance.denom] ?? Colors.blueGrey,
              image: DecorationImage(
                  image: const AssetImage('assets/images/masks/card_luma.png'),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(denomColors[widget.balance.denom] ?? Colors.blueGrey, BlendMode.overlay))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: [
                widget.ibcCoins.getAssets(),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  widget.ibcCoins.getName(),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white, fontSize: 18),
                ),
                const Spacer(),
              ]),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "\$${"${widget.balance.amount.toHumanReadable()}".trimZero()}",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white, fontSize: 24, fontFamily: 'Inter'),
                ),
              ),
            ],
          ),
        ));
  }
}

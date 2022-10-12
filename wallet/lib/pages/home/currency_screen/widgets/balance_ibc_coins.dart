import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/model/amount.dart';
import 'package:pylons_wallet/model/balance.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/formatter.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BalanceIBCCoins extends StatefulWidget {
  final Balance balance;

  const BalanceIBCCoins({Key? key, required this.balance}) : super(key: key);

  @override
  _BalanceIBCCoinsState createState() => _BalanceIBCCoinsState();
}

class _BalanceIBCCoinsState extends State<BalanceIBCCoins> {
  bool showShimmer = true;

  IBCCoins ibcCoins = IBCCoins.urun;

  @override
  void initState() {
    super.initState();

    GetIt.I
        .get<Repository>()
        .getIBCHashTrace(ibcHash: widget.balance.denom.replaceFirst('ibc/', ''))
        .then((value) {
      if (value.isLeft()) {
        return;
      }

      ibcCoins = value.toOption().toNullable()!.denomTrace.baseDenom;
      showShimmer = false;

      setState(() {});
    });
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
                  colorFilter: ColorFilter.mode(
                      denomColors[widget.balance.denom] ?? Colors.blueGrey,
                      BlendMode.overlay))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: [
                Shimmer(
                  enabled: showShimmer,
                  color: Colors.red,
                  child: showShimmer
                      ? SizedBox(
                          width: 30.w,
                          height: 30.w,
                        )
                      : ibcCoins.getAssets(),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Shimmer(
                  color: Colors.red,
                  enabled: showShimmer,
                  child: showShimmer
                      ? SizedBox(
                          width: 60.w,
                          height: 40.w,
                        )
                      : Text(
                          ibcCoins.getName(),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: Colors.white, fontSize: 18),
                        ),
                ),
                const Spacer(),
              ]),
              Align(
                alignment: Alignment.centerRight,
                child: Shimmer(
                  enabled: showShimmer,
                  color: Colors.red,
                  child: showShimmer
                      ? SizedBox(
                          width: 50.w,
                          height: 50.w,
                        )
                      : Text(
                          "\$${"${widget.balance.amount.toHumanReadable()}".trimZero()}",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'Inter'),
                        ),
                ),
              ),
            ],
          ),
        ));
  }
}

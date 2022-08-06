import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/components/loading.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/pages/home/currency_screen/model/ibc_coins.dart';
import 'package:pylons_wallet/pages/home/home_provider.dart';
import 'package:pylons_wallet/pages/home/wallet_screen/widgets/currency_card.dart';
import 'package:pylons_wallet/pages/home/wallet_screen/widgets/row_components.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/formatter.dart';
import 'package:pylons_wallet/utils/linked_scroll_controller.dart';
import 'package:pylons_wallet/utils/route_util.dart';
import 'package:sprintf/sprintf.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late LinkedScrollControllerGroup _controllers;

  late ScrollController scrollControllerOne;
  late ScrollController scrollControllerTwo;

  @override
  void initState() {
    super.initState();

    _controllers = LinkedScrollControllerGroup();

    scrollControllerOne = _controllers.addAndGet();
    scrollControllerTwo = _controllers.addAndGet();

    context.read<HomeProvider>().getTransactionHistoryList();
  }

  @override
  void dispose() {
    scrollControllerTwo.dispose();
    scrollControllerOne.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scheduleMicrotask(() async {
      context.read<HomeProvider>().buildAssetsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        if (provider.balances.isNotEmpty) {
          return SizedBox(
            child: Column(
              children: [
                VerticalSpace(10.h),
                RowComponents(
                  onRefresh: () async {
                    provider.buildAssetsList();
                  },
                ),
                VerticalSpace(10.h),
                Expanded(
                  child: Stack(
                    children: [
                      ReorderableListView.builder(
                        primary: false,
                        scrollController: scrollControllerTwo,
                        onReorder: (oldIndex, newIndex) {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }

                          final previous = provider.items.removeAt(oldIndex);
                          provider.items.insert(newIndex, previous);
                          provider.newOrder(newIndex);
                        },
                        itemCount: provider.items.length,
                        proxyDecorator: (Widget widget, int index, Animation animation) {
                          return widget;
                        },
                        itemBuilder: (context, index) {
                          final currencyModel = provider.items[index];
                          return CurrencyCard(
                            key: ValueKey(index.toString()),
                            isDefault: index == provider.items.length - 2,
                            currencyModel: currencyModel,
                            onFaucetPressed: () {
                              if (currencyModel.ibcCoins.getName() == kPylons) {
                                Navigator.of(context).pushNamed(RouteUtil.ROUTE_ADD_PYLON);
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future getFaucet(BuildContext context, String denom) async {
    final diag = Loading()..showLoading();
    final walletsStore = GetIt.I.get<WalletsStore>();
    final faucetEither = await walletsStore.getFaucetCoin(denom: denom);
    diag.dismiss();
    faucetEither.fold((failure) {
      faucetEither.swap().toOption().toNullable()!.message.show();
    }, (success) {
      sprintf("faucet_added".tr(), [faucetEither.getOrElse(() => 0).toString().UvalToVal(), denom.UdenomToDenom()]).show();
      Timer(const Duration(milliseconds: 400), () {
        context.read<HomeProvider>().buildAssetsList();
      });
    });
  }
}

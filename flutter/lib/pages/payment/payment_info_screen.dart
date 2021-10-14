import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/forms/card_info_form.dart';
import 'package:pylons_wallet/pages/payment/payment_result_screen.dart';

class PaymentInfoScreenWidget extends StatefulWidget {
  const PaymentInfoScreenWidget({Key? key}) : super(key: key);

  @override
  State<PaymentInfoScreenWidget> createState() => _PaymentInfoScreenWidgetState();
}

class _PaymentInfoScreenWidgetState extends State<PaymentInfoScreenWidget> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  // void _tabSelect() {
  //   setState(() {
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(primary: false, slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          snap: true,
          floating: true,
          forceElevated: true,
          toolbarHeight: kAppBarNormalSize,
          collapsedHeight: kAppBarNormalSize,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const ImageIcon(AssetImage('assets/images/icon/before.png'), size: kIconSize, color: kSelectedIcon)),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          //nft image
          const CardInfoForm(),
        ]))
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
          alignment: Alignment.center,
          height: 60,
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaymentResultScreenWidget()));
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF1212C4),
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                minimumSize: const Size(double.infinity, 30), // double.infinity is the width and 30 is the height
              ),
              child: Text('${'pay'.tr()} \$82.00', style: const TextStyle(color: Colors.white)))),
    );
  }
}

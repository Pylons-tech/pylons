import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/forms/card_info_form.dart';
import 'package:pylons_wallet/forms/create_trade_form.dart';
import 'package:pylons_wallet/pages/detail/detail_tab_info.dart';
import 'package:pylons_wallet/pages/detail/detail_tab_work.dart';
import 'package:pylons_wallet/pages/detail/detail_tab_history.dart';
import 'package:pylons_wallet/pages/home/notification.dart';
import 'package:pylons_wallet/pages/payment/payment_info_screen.dart';

class NFTViewWidget extends StatefulWidget {
  const NFTViewWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<NFTViewWidget> createState() => _NFTViewWidgetState();
}

class _NFTViewWidgetState extends State<NFTViewWidget> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: (){
              Navigator.pop(context);
            },
          )
      ),
      body: const Align(
        alignment: Alignment.center,
        child: Image(
          image: CachedNetworkImageProvider(kImage),
          width: double.infinity,
          fit: BoxFit.cover,
        )
      )
    );
  }
}

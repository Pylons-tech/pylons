import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:pylons_wallet/components/nft_view.dart';
import 'package:pylons_wallet/components/notification_item.dart';
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

class DetailScreenWidget extends StatefulWidget {
  final bool isOwner;
  const DetailScreenWidget({
    Key? key,
    required this.isOwner,
  }) : super(key: key);

  @override
  State<DetailScreenWidget> createState() => _DetailScreenWidgetState();
}

class _DetailScreenWidgetState extends State<DetailScreenWidget>
    with SingleTickerProviderStateMixin {
  bool isInResellMode = false;
  bool isInTrade = false;
  int tabIndex = 0;
  late TabController _tabController;

  final List<Widget> myTabs = const <Widget>[
    Padding(
      padding: EdgeInsets.all(4.0),
      child: Text('Work'),
    ),
    Padding(
      padding: EdgeInsets.all(4.0),
      child: Text('Info'),
    ),
    Padding(
      padding: EdgeInsets.all(4.0),
      child: Text('History'),
    ),
  ];

  static const List<Widget> _pages = <Widget>[
    DetailTabWorkWidget(),
    DetailTabInfoWidget(),
    DetailTabHistoryWidget(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(_tabSelect);
  }

  void _tabSelect() {
    setState(() {
      tabIndex = _tabController.index;
    });
  }

  void onPressPurchaseModal() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(30.0),
            topRight: const Radius.circular(30.0),
          ),
        ),
        builder: (context) => new Wrap(children: [const CardInfoForm()]));
  }

  void onPressPurchase() {
    if (!widget.isOwner)
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PaymentInfoScreenWidget()));
    else {
      if (!isInResellMode) {
        //setState(() {
        //  isInResellMode = !isInResellMode;
        //});
        onResellNft();
      }
    }
  }

  void onDeleteTrade() {
    /*
    showDialog(
        context: context,
        builder: AlertDialog(
          title: const Text(''),
          content: const Text('Do you really want to delete trade?'),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(10),
          actions: [
            TextButton(
              onPressed:(){},
              child: const Text('Cancel')
            ),
            TextButton(
              onPressed: (){},
              child: const Text('Delete Trade')
            )
          ]
        )
    );
     */
  }

  void onResellNft() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(30.0),
            topRight: const Radius.circular(30.0),
          ),
        ),
        builder: (context) => new Wrap(children: [const CreateTradeForm()]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
                child: Image.asset(
                  'assets/images/Rectangle 156.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const NFTViewWidget()));
                }),
            const VerticalSpace(10),
            //tab bar
            Container(
                alignment: Alignment.centerLeft,
                height: 30,
                color: Colors.white,
                child: TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[700],
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Color(0xFFED8864),
                  tabs: myTabs,
                  labelPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                )),
            Container(child: _pages[tabIndex])
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
          padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
          alignment: Alignment.center,
          height: 72,
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(children: [
                Text('\$ 82.00',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF201D1D),
                        fontFamily: 'Inter')),
                Spacer(),
                ElevatedButton(
                    onPressed: () {
                      onPressPurchase();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF1212C4),
                        padding: EdgeInsets.fromLTRB(50, 0, 50, 0)),
                    child: Text(!widget.isOwner ? 'Purchase' : 'Resell NFT',
                        style: TextStyle(color: Colors.white)))
              ]),
              /*
              Row(
                  children: [
                    Text('\$ 82.00', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF201D1D), fontFamily: 'Inter')),
                    Spacer(),
                    ElevatedButton(
                        onPressed: (){
                          onDeleteTrade();
                        },
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF080830),
                            padding: EdgeInsets.fromLTRB(50, 0, 50, 0)
                        ),
                        child: Text('Delete Trade', style: TextStyle(color: Colors.white))
                    )
                  ]
              )
               */
            ],
          )),
    );
  }
}

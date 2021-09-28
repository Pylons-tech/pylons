import 'package:flutter/material.dart';
import 'package:pylons_wallet/components/pylons_app_bar.dart';
import 'package:pylons_wallet/components/pylons_history_card.dart';

class HomeActivityWidget extends StatefulWidget {
  const HomeActivityWidget({Key? key}) : super(key: key);

  @override
  State<HomeActivityWidget> createState() => _HomeActivityWidgetState();
}

class _HomeActivityWidgetState extends State<HomeActivityWidget> {


  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.only(top: 30.0),
            child: Center(
              child: PylonsHistoryCard(),
            ),
          );
        },
        childCount: 20,
      ),
    );
  }
}

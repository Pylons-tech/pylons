import 'package:flutter/material.dart';
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
            padding: const EdgeInsets.only(top: 10.0),
            child: const Center(
              child: PylonsHistoryCard(),
            ),
          );
        },
        childCount: 20,
      ),
    );
  }
}

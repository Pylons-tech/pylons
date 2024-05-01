import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/model/pylon_items.dart';
import 'package:pylons_wallet/pages/home/home_provider.dart';

final _kItemStyle = TextStyle(color: Colors.black, fontSize: 9.sp);

final _kHeadingStyle = TextStyle(color: Colors.black, fontSize: 9.sp, fontWeight: FontWeight.bold);

class BlockSlayerScreen extends StatefulWidget {
  const BlockSlayerScreen({super.key});

  @override
  State<BlockSlayerScreen> createState() => _BlockSlayerScreenState();
}

class _BlockSlayerScreenState extends State<BlockSlayerScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeProvider>().getPylonList();
  }

  Widget _getRow({required NonEaselItemModel nonEaselItemModel}) {
    return Row(
      children: [
        Expanded(
            child: Text(
          nonEaselItemModel.cookBookId,
          style: _kItemStyle,
          textAlign: TextAlign.center,
        )),
        Expanded(
            child: Text(
          nonEaselItemModel.coins,
          style: _kItemStyle,
          textAlign: TextAlign.center,
        )),
        Expanded(
            child: Text(
          nonEaselItemModel.currentHp,
          style: _kItemStyle,
          textAlign: TextAlign.center,
        )),
        Expanded(
            child: Text(
          nonEaselItemModel.maxHp,
          style: _kItemStyle,
          textAlign: TextAlign.center,
        )),
        Expanded(
            child: Text(
          nonEaselItemModel.shards,
          style: _kItemStyle,
          textAlign: TextAlign.center,
        )),
        Expanded(
            child: Text(
          nonEaselItemModel.swordLevel,
          style: _kItemStyle,
          textAlign: TextAlign.center,
        )),
        Expanded(
            child: Text(
          nonEaselItemModel.wins,
          style: _kItemStyle,
          textAlign: TextAlign.center,
        )),
      ],
    );
  }

  Widget _getRowHeading() {
    return Row(
      children: [
        Expanded(
            child: Text(
          "CookBook",
          style: _kHeadingStyle,
          textAlign: TextAlign.center,
        )),
        Expanded(
            child: Text(
          "Coins",
          style: _kHeadingStyle,
          textAlign: TextAlign.center,
        )),
        Expanded(
            child: Text(
          "Hp",
          style: _kHeadingStyle,
          textAlign: TextAlign.center,
        )),
        Expanded(
            child: Text(
          "Max Hp",
          style: _kHeadingStyle,
          textAlign: TextAlign.center,
        )),
        Expanded(
            child: Text(
          "Shards",
          style: _kHeadingStyle,
          textAlign: TextAlign.center,
        )),
        Expanded(
            child: Text(
          "Level",
          style: _kHeadingStyle,
          textAlign: TextAlign.center,
        )),
        Expanded(
            child: Text(
          "Wins",
          style: _kHeadingStyle,
          textAlign: TextAlign.center,
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, _) {
      final noEaselPylonItemList = provider.getNoNEaselItems();

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            if (noEaselPylonItemList.isNotEmpty) _getRowHeading(),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return _getRow(nonEaselItemModel: noEaselPylonItemList[index]);
                },
                separatorBuilder: (_, __) => SizedBox(
                  height: 30.h,
                ),
                itemCount: noEaselPylonItemList.length,
              ),
            ),
          ],
        ),
      );
    });
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pylons_wallet/model/nft.dart';
import 'package:pylons_wallet/model/nft_ownership_history.dart';
import 'package:pylons_wallet/utils/constants.dart';
import 'package:pylons_wallet/utils/enums.dart';
import 'package:pylons_wallet/utils/extension.dart';

class TabField extends StatefulWidget {
  final String name;
  final String icon;
  final NFT nft;
  final List<NftOwnershipHistory> NftOwnershipHistoryList;
  final String owner;

  const TabField({Key? key, required this.name, required this.icon, required this.nft, required this.owner, required this.NftOwnershipHistoryList}) : super(key: key);

  @override
  State<TabField> createState() => _TabFieldState();
}

class _TabFieldState extends State<TabField> {
  bool collapsed = true;

  Map<String, String> getOwnershipMap() {
    switch (widget.nft.type) {
      case NftType.TYPE_RECIPE:
        return {
          "owned_by".tr(): widget.owner,
          "edition".tr(): '${widget.nft.amountMinted} of ${widget.nft.quantity}',
          "royalty_text".tr(): widget.nft.tradePercentage,
          "size".tr(): widget.nft.getAssetSize(),
          "creation".tr(): widget.nft.createdAt,
        };
      case NftType.TYPE_ITEM:
        return {
          "owned_by".tr(): widget.owner,
          "size".tr(): widget.nft.getAssetSize(),
          "creation".tr(): widget.nft.createdAt,
        };
      case NftType.TYPE_TRADE:
        return {};
    }
  }

  Map<String, String> getNFTDetailsMap() {
    switch (widget.nft.type) {
      case NftType.TYPE_RECIPE:
        return {"recipe_id".tr(): widget.nft.recipeID, 'blockchain'.tr(): 'pylons'.tr(), 'permission'.tr(): 'exclusive'.tr()};
      case NftType.TYPE_ITEM:
        return {"recipe_id".tr(): widget.nft.recipeID, 'blockchain'.tr(): 'pylons'.tr(), 'permission'.tr(): 'exclusive'.tr()};
      case NftType.TYPE_TRADE:
        break;
    }

    return {"recipe_id".tr(): widget.nft.recipeID, 'blockchain'.tr(): 'pylons'.tr(), 'permission'.tr(): 'exclusive'.tr()};
  }

  @override
  Widget build(BuildContext context) {
    final ownership = getOwnershipMap();

    final nftDetail = getNFTDetailsMap();

    final listOwnership = ownership.entries.map((element) => _tabDetails(field: element.key, value: element.value)).toList();

    final listDetails = nftDetail.entries
        .map((element) => _tabDetails(field: element.key, value: element.value, customWidget: element.key == kRecipeId && element.value.isNotEmpty ? _tabDetailsWithIcon(value: element.value) : null))
        .toList();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 70.w,
                    child: AutoSizeText(
                      widget.name,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  SvgPicture.asset(
                    'assets/images/icons/${widget.icon}.svg',
                    height: widget.icon == 'history' ? 10.h : 20.h,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      setState(() {
                        collapsed = !collapsed;
                      });
                    },
                    child: SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: SvgPicture.asset(
                        'assets/images/icons/${collapsed ? 'add' : 'minus'}.svg',
                      ),
                    ),
                  )
                ],
              ),
              Wrap(
                children: [
                  Container(
                    width: 100.w,
                    height: 10.h,
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white, width: 2))),
                  ),
                  CustomPaint(size: Size(10.w, 10.h), painter: DiagonalLinePainter()),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
          if (!collapsed && widget.name == "ownership".tr())
            ...listOwnership
          else if (!collapsed && widget.name == "nft_detail".tr())
            ...listDetails
          else if (!collapsed && widget.name == "history".tr())
            _listHistory(widget.NftOwnershipHistoryList, context)
        ],
      ),
    );
  }

  Widget _listHistory(List<NftOwnershipHistory> nftOwnershipHistoryList, BuildContext context) {
    return nftOwnershipHistoryList.isNotEmpty
        ? ListView.builder(
            padding: EdgeInsets.zero,
            primary: false,
            shrinkWrap: true,
            itemCount: nftOwnershipHistoryList.length,
            itemBuilder: (context, i) {
              final nftOwnershipHistory = nftOwnershipHistoryList[i];

              final DateTime date = DateTime.fromMillisecondsSinceEpoch(nftOwnershipHistory.createdAt * kNumberOfSeconds);
              final createdDate = date.toLocal();
              final formattedDate = DateFormat(kDateWithTimeFormat).format(createdDate);
              if (i < kMaxItemToShow) {
                return _tabDetails(field: formattedDate, value: nftOwnershipHistory.senderName, customColor: AppColors.kPurple);
              }
              return const SizedBox();
            })
        : const SizedBox();
  }

  Widget _tabDetailsWithIcon({
    required String value,
  }) {
    return Expanded(
      flex: 45,
      child: Row(
        children: [
          Text(
            value.substring(0, 6),
            style:  TextStyle(color: AppColors.kWhite),
          ),
           Text(
            "...",
            style: TextStyle(color: AppColors.kWhite),
          ),
          Text(
            value.substring(value.length - 5, value.length),
            style:  TextStyle(color: AppColors.kWhite),
          ),
          if (value.isNotEmpty)
            InkWell(
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: value));
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("copied_to_clipboard".tr())),
                );
              },
              child: Icon(
                Icons.copy_outlined,
                color: AppColors.kWhite,
                size: 15.h,
              ),
            )
        ],
      ),
    );
  }

  Widget _tabDetails({required String field, required String value, Widget? customWidget, Color? customColor}) {
    return Row(
      children: [
        Expanded(
          flex: 50,
          child: Text(
            field,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        if (customWidget != null) ...[
          customWidget
        ] else ...[
          Expanded(
            flex: 45,
            child: Text(
              value,
              style: TextStyle(color: customColor != null ? AppColors.kPurple : Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]
      ],
    );
  }
}

class DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final point1 = Offset(-0.5, size.height - 1);
    final point2 = Offset(size.width, 0);
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;
    canvas.drawLine(point1, point2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

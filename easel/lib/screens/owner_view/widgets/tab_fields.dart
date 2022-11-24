import 'package:auto_size_text/auto_size_text.dart';
import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/models/nft_ownership_history.dart';
import 'package:easel_flutter/utils/constants.dart';
import 'package:easel_flutter/utils/easel_app_theme.dart';
import 'package:easel_flutter/utils/enums.dart';
import 'package:easel_flutter/utils/extension_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../generated/locale_keys.g.dart';

enum TabFields { ownership, details, history }

// ignore: must_be_immutable
class TabField extends StatefulWidget {
  final String name;
  final String icon;
  final NFT nft;
  final List<NftOwnershipHistory> nftOwnershipHistoryList;
  final String owner;
  bool isExpanded;
  final Function(TabFields) onChangeTab;

  TabField({
    Key? key,
    required this.name,
    required this.icon,
    required this.nft,
    required this.owner,
    required this.nftOwnershipHistoryList,
    required this.isExpanded,
    required this.onChangeTab,
  }) : super(key: key);

  @override
  State<TabField> createState() => _TabFieldState();
}

class _TabFieldState extends State<TabField> {
  bool collapsed = true;

  Map<String, String> getOwnershipMap() {
    switch (widget.nft.type.toNftTypeEnum()) {
      case NftType.TYPE_RECIPE:
        return {
          "owner": widget.owner,
          "edition#": '#${widget.nft.amountMinted} of ${widget.nft.quantity}',
          "rotality": widget.nft.tradePercentage,
        };
      case NftType.TYPE_ITEM:
        return {
          "owner": widget.owner,
        };
      case NftType.TYPE_TRADE:
        return {};
    }
  }

  Map<String, String> getNFTDetailsMap() {
    switch (widget.nft.type.toNftTypeEnum()) {
      case NftType.TYPE_RECIPE:
        return {
          "recipe id": widget.nft.recipeID,
          "resolution": "${widget.nft.width}x${widget.nft.height}",
          "ipfs id": widget.nft.cid,
        };
      case NftType.TYPE_ITEM:
        return {
          "recipe": widget.nft.recipeID,
        };
      case NftType.TYPE_TRADE:
        break;
    }

    return {
      "recipe": widget.nft.recipeID,
      "resolution": "${widget.nft.width}x${widget.nft.height}",
      "ipfs": widget.nft.cid,
    };
  }

  @override
  Widget build(BuildContext context) {
    final ownership = getOwnershipMap();

    final nftDetail = getNFTDetailsMap();

    final listOwnership = ownership.entries.map((element) => _tabDetails(field: element.key, value: element.value, customColor: element.key == 'owner' ? Colors.red : null)).toList();

    final listDetails = nftDetail.entries
        .map(
          (element) => _tabDetails(
              field: element.key,
              value: element.value,
              customWidget: (element.key == "recipe id" || element.key == "ipfs") && element.value.isNotEmpty ? _tabDetailsWithIcon(value: element.value) : null),
        )
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
                      TabFields? _field;
                      if (widget.name == "owner ship") {
                        _field = TabFields.ownership;
                      } else if (widget.name == "nft detail") {
                        _field = TabFields.details;
                      } else {
                        _field = TabFields.history;
                      }

                      widget.onChangeTab(_field);
                      setState(() {
                        widget.isExpanded = !widget.isExpanded;
                      });
                    },
                    child: SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: SvgPicture.asset(
                        'assets/images/icons/${!widget.isExpanded ? 'add' : 'minus'}.svg',
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
          if (widget.name == "ownership" && widget.isExpanded)
            ...listOwnership
          else if (widget.name == "nft_details" && widget.isExpanded)
            ...listDetails
          else if (widget.name == "history" && widget.isExpanded)
            _listHistory(widget.nftOwnershipHistoryList, context)
        ],
      ),
    );
  }

  Widget? customWidget(MapEntry<String, String> element) {
    return element.key == kRecipeId && element.value.isNotEmpty
        ? _tabDetailsWithIcon(value: element.value)
        : element.key == kIpfsCid && element.value.isNotEmpty
            ? _tabDetailsWithIcon(value: element.value)
            : null;
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
                return _tabDetails(field: formattedDate, value: nftOwnershipHistory.senderName, customColor: EaselAppTheme.kLightPurple2);
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
            style: TextStyle(color: EaselAppTheme.kGreyColor, fontSize: 9.sp),
          ),
          Text(
            "...",
            style: TextStyle(color: EaselAppTheme.kGreyColor, fontSize: 9.sp),
          ),
          Text(
            value.substring(value.length - 5, value.length),
            style: TextStyle(color: EaselAppTheme.kGreyColor, fontSize: 9.sp),
          ),
          if (value.isNotEmpty)
            InkWell(
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: value));
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(LocaleKeys.copied_to_clipboard.tr())),
                );
              },
              child: Icon(
                Icons.copy_outlined,
                color: EaselAppTheme.kGreyColor,
                size: 11.h,
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
            style: TextStyle(color: EaselAppTheme.kGreyColor, fontSize: 9.sp),
          ),
        ),
        if (customWidget != null) ...[
          customWidget
        ] else ...[
          Expanded(
            flex: 45,
            child: Text(
              value,
              style: TextStyle(
                color: customColor != null ? EaselAppTheme.kLightPurple2 : EaselAppTheme.kGreyColor,
                fontSize: 9.sp,
              ),
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

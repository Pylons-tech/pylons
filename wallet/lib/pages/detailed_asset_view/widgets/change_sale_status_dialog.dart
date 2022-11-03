import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pylons_wallet/utils/clipper_utils.dart';
import 'package:pylons_wallet/utils/enums.dart' as enums;
import 'package:pylons_wallet/utils/image_util.dart';
import 'package:pylons_wallet/utils/svg_util.dart';

import '../../../main_prod.dart';
import '../../../model/denom.dart';
import '../../../utils/constants.dart';
import '../owner_view_view_model.dart';

class ChangeSaleStatusDialog {
  final BuildContext buildContext;
  final OwnerViewViewModel ownerViewViewModel;

  ChangeSaleStatusDialog({required this.buildContext, required this.ownerViewViewModel});

  void show() {
    showDialog(
      context: buildContext,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ChangeNotifierProvider<OwnerViewViewModel>.value(
            value: ownerViewViewModel,
            builder: (context, snapshot) {
              return ChangeSaleStatusWidget(
                ownerViewViewModel: ownerViewViewModel,
              );
            },
          ),
        );
      },
    );
  }
}

class ChangeSaleStatusWidget extends StatefulWidget {
  final OwnerViewViewModel ownerViewViewModel;

  const ChangeSaleStatusWidget({Key? key, required this.ownerViewViewModel}) : super(key: key);

  @override
  State<ChangeSaleStatusWidget> createState() => _ChangeSaleStatusWidgetState();
}

class _ChangeSaleStatusWidgetState extends State<ChangeSaleStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      height: isTablet ? 330.h : 380.h,
      margin: isTablet ? EdgeInsets.symmetric(horizontal: 30.w) : EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: SizedBox(
              height: 60,
              width: 80,
              child: ClipPath(
                clipper: RightTriangleClipper(orientation: enums.Orientation.Orientation_SW),
                child: ColoredBox(
                  color: AppColors.kDarkRed,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Image.asset(
                "assets/images/icons/close.png",
                width: 30.w,
                height: 30.h,
                color: AppColors.kWhite,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "nft_listing".tr(),
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.sp, fontFamily: kUniversalSans750FontFamily),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 15.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "NFT",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.sp, fontFamily: kUniversalSans750FontFamily),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        widget.ownerViewViewModel.nft.name,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.sp, fontFamily: kUniversalSans750FontFamily),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "artist".tr(),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.sp, fontFamily: kUniversalSans750FontFamily),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(flex: 4, child: Text(widget.ownerViewViewModel.nft.creator, style: TextStyle(color: AppColors.kCopyColor, fontSize: 13.sp, fontFamily: kUniversalSans500FontFamily))),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "sold_by".tr(),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.sp, fontFamily: kUniversalSans750FontFamily),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(flex: 4, child: Text(widget.ownerViewViewModel.nft.owner, style: TextStyle(color: AppColors.kCopyColor, fontSize: 13.sp, fontFamily: kUniversalSans500FontFamily))),
                  ],
                ),
                SizedBox(height: 30.h),
                const PriceInputField(),
                SizedBox(height: 10.h),
                Text("network_fee".tr(), style: TextStyle(color: AppColors.kCopyColor, fontSize: 13.sp, fontFamily: kUniversalSans750FontFamily)),
                SizedBox(height: 30.h),
                Consumer<OwnerViewViewModel>(
                  builder: (_, ownerViewViewModel, _a) {
                    return InkWell(
                      onTap: (double.parse(ownerViewViewModel.priceController.text.replaceAll(",", "")) <= 0)
                          ? null
                          : (){
                              widget.ownerViewViewModel.updateRecipeIsEnabled(context: context, viewModel: widget.ownerViewViewModel);
                            },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            SVGUtil.BUTTON_BACKGROUND,
                            width: 360.w,
                            height: 50.h,
                          ),
                          Visibility(visible: double.parse(ownerViewViewModel.priceController.text.replaceAll(",", "")) <= 0,child: ColoredBox(color: Colors.black54,child: SizedBox(width: 360.w, height: 50.h,),)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              children: [
                                Visibility(
                                  visible: ! (double.parse(ownerViewViewModel.priceController.text.replaceAll(",", "")) <= 0),
                                  child: SizedBox(height: 17.h, width: 17.w, child: SvgPicture.asset(SVGUtil.PYLONS_POINTS_ICON)),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: !(double.parse(ownerViewViewModel.priceController.text.replaceAll(",", "")) <= 0)?CrossAxisAlignment.start:CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                  double.parse(ownerViewViewModel.priceController.text.replaceAll(",", "")) <= 0? "input_valid_price".tr()
                                            : "${"list_for".tr()} ${ownerViewViewModel.priceController.text} ${"pylon_points".tr()}",
                                        style: TextStyle(color: AppColors.kWhite, fontSize: 11.sp, fontFamily: kUniversalSans750FontFamily),
                                      ),
                                      Visibility(
                                        visible: !(double.parse(ownerViewViewModel.priceController.text.replaceAll(",", "")) <= 0),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text("(\$100 USD)".tr(), style: TextStyle(color: AppColors.kWhite, fontSize: 9.sp, fontFamily: kUniversalSans400FontFamily)),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PriceInputField extends StatelessWidget {
  const PriceInputField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "price".tr(),
          textAlign: TextAlign.start,
          style: TextStyle(color: AppColors.kWhite, fontWeight: FontWeight.bold, fontSize: 15.sp, fontFamily: kUniversalSans750FontFamily),
        ),
        SizedBox(height: 4.h),
        Stack(
          children: [
            Positioned(
              child: SvgPicture.asset(
                SVGUtil.GREY_COLOR_BG,
                width: 1.sw,
                height: isTablet ? 32.h : 40.h,
                fit: BoxFit.fill,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: _CurrencyDropDown()),
                Expanded(
                  child: Consumer<OwnerViewViewModel>(
                    builder: (_, ownerViewViewModel, _a) {
                      return TextFormField(
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: AppColors.kWhite),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(kMaxPriceLength), ownerViewViewModel.selectedDenom.getFormatter()],
                        controller: ownerViewViewModel.priceController,
                        minLines: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "0.00",
                          hintStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: AppColors.kWhite),
                          border: const OutlineInputBorder(borderSide: BorderSide.none),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
                        ),
                        onChanged: ownerViewViewModel.onPriceChanged,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _CurrencyDropDown extends StatelessWidget {
  const _CurrencyDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OwnerViewViewModel>(
      builder: (_, ownerViewViewModel, __) => Stack(
        alignment: Alignment.centerLeft,
        fit: StackFit.passthrough,
        children: [
          SvgPicture.asset(SVGUtil.RED_BG, height: isTablet ? 32.h : 40.h, fit: BoxFit.fitWidth),
          Container(
            padding: EdgeInsets.only(left: 5.w),
            height: isTablet ? 32.h : 40.h,
            child: Align(
              child: DropdownButton<String>(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                value: ownerViewViewModel.selectedDenom.symbol,
                isExpanded: true,
                iconSize: 0,
                elevation: 0,
                underline: const SizedBox(),
                dropdownColor: AppColors.kDarkRed,
                style: TextStyle(color: AppColors.kWhite, fontSize: 18.sp, fontWeight: FontWeight.w400),
                onChanged: (String? data) {
                  if (data != null) {
                    final value = ownerViewViewModel.supportedDenomList.firstWhere((denom) => denom.symbol == data);
                    ownerViewViewModel.priceController.clear();
                    ownerViewViewModel.setSelectedDenom(value);
                  }
                },
                items: ownerViewViewModel.supportedDenomList.map((Denom value) {
                  return DropdownMenuItem<String>(
                    value: value.symbol,
                    child: Row(
                      children: [
                        value.getIconWidget(),
                        SizedBox(width: isTablet ? 10.w : 10.w),
                        Text(
                          value.name,
                          style: TextStyle(fontSize: isTablet ? 13.sp : 15.sp),
                        ),
                        SizedBox(width: isTablet ? 0.w : 5.w),
                        Image.asset(
                          ImageUtil.DROPDOWN_ICON,
                          color: AppColors.kWhite,
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:evently/evently_provider.dart';
import 'package:evently/utils/constants.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../generated/locale_keys.g.dart';
import '../main.dart';
import '../models/denom.dart';

class EventlyPriceInputField extends StatelessWidget {
  const EventlyPriceInputField({super.key, this.controller, this.validator, this.inputFormatters = const []});

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.price.tr(),
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 4.h),
        Stack(
          children: [
            Positioned(
              child: Image.asset(PngUtils.kTextFieldSingleLine, width: 1.sw, height: isTablet ? 32.h : 40.h, fit: BoxFit.fill),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: TextFormField(
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400, color: EventlyAppTheme.kDarkText),
                        controller: controller,
                        validator: validator,
                        minLines: 1,
                        keyboardType: TextInputType.number,
                        inputFormatters: inputFormatters,
                        decoration: InputDecoration(
                            hintText: LocaleKeys.network_fee_listed_price_occur_on_chain.tr(),
                            hintStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: EventlyAppTheme.kGrey),
                            border: const OutlineInputBorder(borderSide: BorderSide.none),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h)))),
                const _CurrencyDropDown()
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
    return Consumer<EventlyProvider>(
        builder: (_, provider, __) => Stack(
              alignment: Alignment.center,
              children: [
                Positioned(left: 0, top: 0, bottom: 0, right: 0, child: Image.asset(PngUtils.kTextFieldButton, height: isTablet ? 32.h : 40.h, fit: BoxFit.fill)),
                Container(
                    padding: EdgeInsets.only(left: 5.w),
                    height: isTablet ? 32.h : 40.h,
                    child: Align(
                      child: DropdownButton<String>(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        value: provider.selectedDenom.symbol,
                        iconSize: 0,
                        elevation: 0,
                        underline: const SizedBox(),
                        dropdownColor: EventlyAppTheme.kPurple03,
                        style: TextStyle(color: EventlyAppTheme.kWhite, fontSize: 18.sp, fontWeight: FontWeight.w400),
                        onChanged: (String? data) {
                          if (data != null) {
                            final value = provider.supportedDenomList.firstWhere((denom) => denom.symbol == data);
                            provider.priceController.clear();
                            provider.setSelectedDenom(value);
                          }
                        },
                        items: provider.supportedDenomList.map((Denom value) {
                          return DropdownMenuItem<String>(
                            value: value.symbol,
                            child: Row(children: [
                              value.getIconWidget(),
                              SizedBox(width: isTablet ? 10.w : 10.w),
                              Text(
                                value.name,
                                style: TextStyle(fontSize: isTablet ? 16.sp : 18.sp),
                              ),
                              SizedBox(width: isTablet ? 0.w : 5.w),
                            ]),
                          );
                        }).toList(),
                      ),
                    )),
              ],
            ));
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:evently/generated/locale_keys.g.dart';
import 'package:evently/utils/evently_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuyerResponseScreen extends StatefulWidget {
  const BuyerResponseScreen({super.key});

  @override
  State<BuyerResponseScreen> createState() => _BuyerResponseScreenState();
}

class _BuyerResponseScreenState extends State<BuyerResponseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventlyAppTheme.kLightGreen,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.enjoy_the_event.tr(),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: EventlyAppTheme.kWhite),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              height: 161,
              width: 161,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: EventlyAppTheme.kWhite),
              child: const Icon(
                Icons.check,
                size: 161,
                color: EventlyAppTheme.kLightGreen,
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EventlyAppTheme {
  static const Color kWhite = Color(0xFFFFFFFF);
  static const Color kBlack = Color(0xFF000000);
  static const Color kTransparent = Colors.transparent;

  ///* text color variations
  static const Color kTextBlack = Color(0xFF040214);
  static const Color kTextDarkBlue = Color(0xFF080830);
  static const Color kTextLightBlue = Color(0xFF1212C4);
  static const Color kTextLightPurple = Color(0xFFCBC8F3);
  static const Color kTextGrey = Color(0xFF8D8C8C);
  static const Color kTextDarkPurple = Color(0xFFB6B6E8);
  static const Color kTextGrey02 = Color(0xFF9B9A9A);
  static const Color kGreenText = Color(0xFF14FB00);

  static const Color kBlue = Color(0xFF1212C4);
  static const Color kGrey01 = Color(0xFF707070);
  static const Color kGrey02 = Color(0xFF8D8C8C);
  static const Color kGery03 = Color(0xFFC4C4C4);
  static const Color kGrey04 = Color(0xFFA1A1A1);
  static const Color kGreen = Color(0xFF0CAF59);

  static const String universalSansFamily = "UniversalSans";

  static ThemeData theme(BuildContext context) => ThemeData(
        primaryColor: kWhite,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: kWhite,
        visualDensity: VisualDensity.standard,
      );

  static TextStyle titleStyle = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w800,
    color: EventlyAppTheme.kBlack,
    fontFamily: universalSansFamily,
  );
  static TextStyle digitTextStyle = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w800,
    color: EventlyAppTheme.kWhite,
    fontFamily: universalSansFamily,
  );

  static TextStyle kDeleteHeaderTextStyle = TextStyle(fontSize: 14.sp, fontFamily: 'UniversalSans', color: EventlyAppTheme.kWhite, fontWeight: FontWeight.w600);
}

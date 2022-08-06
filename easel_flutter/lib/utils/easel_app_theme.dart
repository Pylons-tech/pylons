import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EaselAppTheme {
  static const Color kWhite = Color(0xFFFFFFFF);
  static const Color kBgColor = Color.fromRGBO(242, 239, 234, 1);
  static const Color kGrey = Color(0xFF8D8C8C);
  static const Color kLightGreyText = Color(0xFF9B9A9A);
  static const Color kLightGrey = Color(0xFFC4C4C4);
  static const Color kLightGrey02 = Color(0xFFF2EFEA);
  static const Color kDartGrey = Color(0xFF333333);
  static const Color kDartGrey02 = Color(0xFFA1A1A1);
  static const Color kBlack = Colors.black;
  static const Color kTransparent = Colors.transparent;
  static const Color kBlue = Color(0xFF1212C4);
  static const Color kDarkText = Color(0xFF080830);
  static const Color kLightText = Color(0xFF464545);
  static const Color kNightBlue = Color(0xFF0A004A);
  static const Color kLightWhiteBackground = Color(0xFFE5E5E5);
  static const Color kRed = Color(0xFFFC4403);
  static const Color kWhite02 = Color.fromRGBO(255, 255, 255, 0.2);
  static const Color kWhite03 = Color(0xFFFBFBFB);
  static const Color kPurple01 = Color.fromRGBO(18, 18, 196, 0.6);
  static const Color kDarkBlue = Color.fromRGBO(18, 18, 196, 1);
  static const Color kPurple02 = Color(0xFF4534CE);
  static const Color kPurple03 = Color(0xFFCBC8F3);
  static const Color kLightPurple = Color(0xFFB6B6E8);
  static const Color kDarkGreen = Color(0xFF3A8977);
  static const Color kYellow = Color(0xFFF3BA2F);
  static const Color kLightRed = Color(0xFFEF4421);
  static const Color kBgWhite = Color(0xFFE5E5E5);
  static const Color kLightBlackText = Color(0xFFA0A6AB);
  static const Color kpurpleButtonColor = Color(0xFF8F8FCE);
  static const Color kpurpleDark = Color(0xFF1212C4);
  static const Color kTextGrey = Color(0xFF7A7A8F);
  static const Color kGreyIcon = Color(0xFFAEAEAE);

  static const Color kLightGreyColor = Color(0xFFE5E5E5);
  static const Color kPurple = Color(0xFF4421CC);
  static const Color kHashtagColor = Color(0xFFB6B6E8);



  static const String universalSansFamily = "UniversalSans";

  static ThemeData theme(BuildContext context) => ThemeData(
        backgroundColor: kWhite,
        primaryColor: kWhite,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: kWhite,
        visualDensity: VisualDensity.standard,
      );

  static Color cardBackground = const Color(0xFFC4C4C4).withOpacity(0.2);
  static Color cardBackgroundSelected = const Color(0x801212C4).withOpacity(0.2);

  static TextStyle titleStyle = TextStyle(
    fontSize:  18.sp,
    fontWeight: FontWeight.w800,
    color: EaselAppTheme.kBlack,
    fontFamily: universalSansFamily,
  );
  static TextStyle digitTextStyle = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w800,
    color: EaselAppTheme.kWhite,
    fontFamily: universalSansFamily,
  );

  static TextStyle kDeleteHeaderTextStyle = TextStyle(fontSize: 14.sp, fontFamily: 'UniversalSans', color: EaselAppTheme.kWhite, fontWeight: FontWeight.w600);

}

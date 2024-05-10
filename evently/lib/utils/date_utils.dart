import 'package:easy_localization/easy_localization.dart';

String getDate() {
  return DateFormat.yMd('en_US').format(DateTime.now());
}

String getFullDateTime() {
  return DateFormat('yyyy_MM_dd_HHmmss_SSS').format(DateTime.now());
}

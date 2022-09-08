import 'package:intl/intl.dart';

String formatDate(DateTime date, DateFormatEnum dateFormat) => DateFormat(getDateFormat[dateFormat]).format(date);

String extractMonth(String groupedMonthYear) => groupedMonthYear.split('-')[0];

abstract class DateFormats {
  static const String uiShortDate = 'MMM d';
  static const String groupByMonthYear = 'MMMM-yyyy';
}

enum DateFormatEnum {
  shortUIDateDay,
  groupByMonthYear,
}

Map<DateFormatEnum, String> getDateFormat = {
  DateFormatEnum.shortUIDateDay: DateFormats.uiShortDate,
  DateFormatEnum.groupByMonthYear: DateFormats.groupByMonthYear,
};

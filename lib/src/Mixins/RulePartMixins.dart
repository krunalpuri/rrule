import 'package:logger/logger.dart';
import 'package:rrule/src/Helpers/WeekDays2Code.dart';

import '../../rrule.dart';

mixin ByMonth {
  checkByMonth(byMonth, inputDate) {
    return (byMonth != null && !byMonth.contains(inputDate.month))
        ? false
        : true;
  }
}

mixin ByMonthDay {
  checkByMonthDay(byMonthDay, inputDate) {
    if (byMonthDay != null) {
      // get the inputDate monthDay (date and count from last date)
      int monthDay = inputDate.day;
      // Setting date zero for next month gives last date of current month
      var monthEndDate = DateTime(inputDate.year, inputDate.month + 1, 0);
      // inputDay minus the monthEndDay
      int monthDayNegative = monthDay - monthEndDate.day;

      // if neither values are in byMonthDay list, return false
      return (!(byMonthDay.contains(monthDay) ||
              byMonthDay.contains(monthDayNegative)))
          ? false
          : true;
    } else {
      return true;
    }
  }
}

mixin ByDay {
  checkByDay(byDay, inputDate) {
    return (byDay != null && !byDay.contains(inputDate.weekday)) ? false : true;
  }
}

mixin ByDayExpand {
  RegExp expandRegex = new RegExp(r"(?:[+|-]?\d+)");

  checkByDayExpand(List<String> byDayExpand, DateTime inputDate) {
    return ((byDayExpand != null && byDayExpand.isNotEmpty) &&
            !validateByDayExpand(byDayExpand, inputDate))
        ? false
        : true;
  }

  validateByDayExpand(List<String> byDayExpand, DateTime inputDate) {
    // assuming byDay is already called, so the weekday is already verified
    // verify the +1MO/ -1MO is satisfied by finding the date of the month.
    // Ex: +1MO would validate as true
    //  if inputDate is same as date of first monday of the inputDate's month.
    int monthDay = inputDate.day;

    // for each item in byDayExpand
    // perform these actions:
    // For ex, for +1MO(-1MO) get the first(last) Monday of the month
    // if the expandMonthDay = monthDay , return true and break the iteration loop
    for (String expandString in byDayExpand) {
      int expandMonthDay = getExpandMonthDay(expandString, inputDate);
      if (expandMonthDay == monthDay) {
        return true;
      }
    }
    return false;
  }

  int getExpandMonthDay(String expandString, DateTime inputDate) {
    int expandDay;
    Logger logger = Logger();
    // TODO: The expand could be either +1, 1 or -1
    Iterable<Match> matches = expandRegex.allMatches(expandString);
    if(matches== null && matches.isEmpty){
      logger.d("getExpandDay: no matches found");
      return null;
    }
    int prefix = int.parse(matches.first.group(0));
    String suffix = expandString.replaceAll(expandRegex, "");
    logger.e(suffix);
    int expandDayCode = convertWeekdaysToInt(suffix);
    // TODO : Return expand day (to finish the monthly strategy checkStatusOnDate
    // get weekDay and MonthDay of first(last) Day of the inputDate
    // decrement till the required code is available
    if(prefix > 0){
      expandDay = findMonthFirstDay(prefix, expandDayCode, inputDate);
    } else{
      expandDay = findMonthFirstDay(prefix, expandDayCode, inputDate);
    }

    return expandDay;
  }

  int findMonthFirstDay(prefix, dayCode, DateTime inputDate){
    int day;
    var tempDate = new DateTime(inputDate.year, inputDate.month, 1);
    var firstWeekDay = tempDate.weekday;

    if(firstWeekDay > dayCode){
      day = 1 + (7 - (firstWeekDay - dayCode));
    }else{
      day = 1 + (dayCode - firstWeekDay);
    }
    return day;
  }

  int findMonthLastWeekDay(prefix, dayCode, DateTime inputDate){
    int day;
    var tempDate = new DateTime(inputDate.year, inputDate.month + 1, 0);
    var lastDay = tempDate.day;
    var lastWeekDay = tempDate.weekday;
    logger.i(lastWeekDay);

    if(lastWeekDay > dayCode){
      day = lastDay - (lastWeekDay - dayCode);
    }else{
      day = lastDay - ( 7 - (dayCode - lastWeekDay));
    }
    return day;
  }
}

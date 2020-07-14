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
      int monthDayNegative = monthDay - monthEndDate.day - 1 ;
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

  checkByDayExpand(List<String> byDayExpand, DateTime inputDate,
      {String strategy = "Monthly"}) {
    return ((byDayExpand != null && byDayExpand.isNotEmpty) &&
            !validateByDayExpand(byDayExpand, inputDate, strategy))
        ? false
        : true;
  }

  validateByDayExpand(
      List<String> byDayExpand, DateTime inputDate, String strategy) {
    if (strategy == "Monthly") {
      // assuming byDay is already called, so the weekday is already verified
      // verify the +1MO/ -1MO is satisfied by finding the date of the month.
      // Ex: +1MO would validate as true
      //  if inputDate is same as date of first monday of the inputDate's month.
      int inputDay = inputDate.day;

      // for each item in byDayExpand
      // perform these actions:
      // For ex, for +1MO(-1MO) get the first(last) Monday of the month
      // if the expandMonthDay = inputDay , return true and break the iteration loop
      for (String expandString in byDayExpand) {
        int expandMonthDay = getExpandMonthDay(expandString, inputDate);
        if (expandMonthDay == inputDay) {
          return true;
        }
      }
    } else if (strategy == "Yearly") {
      int inputDay = inputDate.day;
      for (String expandString in byDayExpand) {
//        logger.e(expandString);
        bool result = checkExpandYearDayMatchesInput(expandString, inputDate);
        if (result) {
          return true;
        }
      }
    } else {
      throw Exception("No valid strategy found");
    }
    return false;
  }

  int getExpandMonthDay(String expandString, DateTime inputDate) {
    int expandDay;
    Logger logger = Logger();
    Iterable<Match> matches = expandRegex.allMatches(expandString);
    if (matches == null && matches.isEmpty) {
      logger.d("getExpandDay: no matches found");
      return null;
    }
    int prefix = int.parse(matches.first.group(0));
    String suffix = expandString.replaceAll(expandRegex, "");
//    logger.i(suffix);
    int expandDayCode = convertWeekdaysToInt(suffix);
    // Return expand day (to finish the monthly strategy checkStatusOnDate
    if (prefix > 0) {
      expandDay = findMonthFirstDay(prefix, expandDayCode, inputDate);
    } else {
      expandDay = findMonthLastDay(prefix, expandDayCode, inputDate);
    }

    return expandDay;
  }

  // If the specified ByDayExpand does not exist in the month, return 0
  int findMonthFirstDay(int prefix, dayCode, DateTime inputDate) {
    int day;
    var beginDate = new DateTime(inputDate.year, inputDate.month, 1);
    var endDate = new DateTime(inputDate.year, inputDate.month + 1, 0);
    var firstWeekDay = beginDate.weekday;

    if (firstWeekDay > dayCode) {
      day = 1 + (7 - (firstWeekDay - dayCode));
    } else {
      day = 1 + (dayCode - firstWeekDay);
    }

    // Check if prefix specified date is valid
    var checkDay = day + (7 * (prefix - 1));
    if (checkDay < endDate.day) {
      return checkDay;
    } else {
      return 0;
    }
  }

  int findMonthLastDay(int prefix, dayCode, DateTime inputDate) {
    int day;
    var endDate = new DateTime(inputDate.year, inputDate.month + 1, 0);
    var lastDay = endDate.day;
    var lastWeekDay = endDate.weekday;
//    logger.i(lastWeekDay);

    if (lastWeekDay > dayCode) {
      day = lastDay - (lastWeekDay - dayCode);
    } else {
      if (dayCode == lastWeekDay) {
        day = lastDay;
      } else {
        day = lastDay - (7 - (dayCode - lastWeekDay));
      }
//      logger.i(lastDay.toString() + " " + dayCode.toString() + " " + lastWeekDay.toString());
    }

    // Check if prefix specified date is valid
    var checkDay = day - (7 * (prefix.abs() - 1));
//    logger.i( "CheckDay:" + checkDay.toString() + " prefix: " + prefix.toString());
    if (checkDay >= 1) {
      return checkDay;
    } else {
      return 0;
    }
  }

  bool checkExpandYearDayMatchesInput(String expandString, DateTime inputDate) {
    bool result;
    Logger logger = Logger();
    Iterable<Match> matches = expandRegex.allMatches(expandString);
    if (matches == null && matches.isEmpty) {
      logger.d("getExpandYearDay: no matches found");
      return null;
    }
    int prefixCount = int.parse(matches.first.group(0));
    String suffix = expandString.replaceAll(expandRegex, "");
    int expandDayCode = convertWeekdaysToInt(suffix);

    // check if the expandYearDay is the same as inputDate/
    result = compareDates(prefixCount, expandDayCode, inputDate);
    return result;
  }

  // find the expandDate
  bool compareDates(int prefixCount, dayCode, DateTime inputDate) {
    if (prefixCount > 0) {
      // find the dayCount from the first day of year
      DateTime firstDayOfYear = new DateTime.utc(inputDate.year, 1, 1);
      int firstWeekDayOfYear = firstDayOfYear.weekday;
//      logger.e(firstDayOfYear.toString() + "\n" + firstWeekDayOfYear.toString());
      int daysCountExpandDate = 1;
      if(dayCode >= firstWeekDayOfYear) {
        daysCountExpandDate  +=
            (dayCode - firstWeekDayOfYear) +
            (7 * (prefixCount - 1));
      }else{
//        logger.d(firstWeekDayOfYear.toString() + "\n" + dayCode.toString());
        daysCountExpandDate +=
            (7 - (firstWeekDayOfYear - dayCode)%7) +
                (7 * (prefixCount - 1));
      }

      // find the dayCount of input from the first day of year
      int daysCountInputDate = inputDate.difference(firstDayOfYear).inDays + 1;
//      logger.e( prefixCount.toString() + dayCode.toString() + "\n" +"DaysCountExpandDate: " + daysCountExpandDate.toString() + " \n" +
//          "DaysCountInputDate: " + daysCountInputDate.toString());
      return (daysCountExpandDate == daysCountInputDate);
    } else {
      //TODO: When prefixCount is negative
      throw UnimplementedError();
    }
  }
}

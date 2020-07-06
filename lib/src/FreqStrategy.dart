import 'package:logger/logger.dart';
import 'package:rrule/src/ENUMS/RepeatType.dart';

import 'ENUMS/FreqType.dart';
import 'Helpers/WeekDays2Code.dart';

final logger = Logger();

abstract class FreqStrategy {
  final rulePartMap;
  final DateTime startTime, endTime;
  final FreqType ruleType;
  int interval = 1;
  int count;
  DateTime until;
  RepeatType repeatType = RepeatType.FOREVER;
  int weekStart;

  FreqStrategy(
      {this.rulePartMap,
      this.startTime,
      this.endTime,
      this.ruleType = FreqType.FREQ_UNSUPPORTED}) {
    getInterval();
    getRepeatType();
    getWeekStart();
  }

  List<DateTime> getEventDates({DateTime upUntil, DateTime fromTime});

  bool checkStatusOnDate(DateTime dateTime);

  FreqType getRuleType();

  // get Rule parts
  void getInterval() {
    if (rulePartMap.containsKey("INTERVAL")) {
      logger.d("INTERVAL FOUND");
      interval = int.parse(rulePartMap["INTERVAL"]);
    }
  }

  void getRepeatType() {
    if (rulePartMap.containsKey("COUNT")) {
      logger.d("COUNT FOUND");
      count = int.parse(rulePartMap["COUNT"]);
      repeatType = RepeatType.COUNT;
    } else if (rulePartMap.containsKey("UNTIL")) {
      logger.d("UNTIL FOUND");
      until = DateTime.parse(rulePartMap["UNTIL"]);
      repeatType = RepeatType.UNTIL;
    }
  }

  List<int> getByMonth() {
    if (rulePartMap.containsKey("BYMONTH")) {
      logger.d("BYMONTH FOUND");
      List<String> monthsString = rulePartMap["BYMONTH"].split(",");
      List<int> byMonth = monthsString.map(int.parse).toList();
      return byMonth;
    }
    return null;
  }

  List<int> getByMonthDay() {
    if (rulePartMap.containsKey("BYMONTHDAY")) {
      logger.d("BYMONTHDAY FOUND");
      List<String> monthDaysString = rulePartMap["BYMONTHDAY"].split(",");
      List<int> byMonthDays = monthDaysString.map(int.parse).toList();
      return byMonthDays;
    }
    return null;
  }

  List<int> getByDay() {
    if (rulePartMap.containsKey("BYDAY")) {
      logger.d("BYDAY FOUND");
      List<String> weekdaysCode = rulePartMap["BYDAY"].split(",");
      List<int> weekDays = weekdaysCode.map(convertWeekdaysToInt).toList();
      return weekDays;
    }
    return null;
  }

  void getWeekStart() {
    if (rulePartMap.containsKey("WKST")) {
      logger.d("WKST FOUND");
      weekStart = convertWeekdaysToInt(rulePartMap["WKST"]);
    } else {
      weekStart = convertWeekdaysToInt("MO");
    }
  }

  @override
  String toString() {
    return 'FreqStrategy{rulePartMap: $rulePartMap, startTime: $startTime, endTime: $endTime, ruleType: $ruleType, interval: $interval, count: $count, until: $until, repeatType: $repeatType}';
  }

  DateTime copyTimeOnly({from, to}) {
    return to.add(Duration(
        hours: from.hour,
        minutes: from.minute,
        seconds: from.second,
        microseconds: from.microsecond,
        milliseconds: from.millisecond));
  }

  bool validInputDate(inputDate) {
    if (inputDate.difference(startTime).isNegative) {
      logger.i("inputDate is before the startTime");
      return false;
    }
    return true;
  }
}



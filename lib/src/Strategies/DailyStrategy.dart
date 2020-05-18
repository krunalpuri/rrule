import 'package:rrule/src/ENUMS/FreqType.dart';
import 'package:rrule/src/Enums/RepeatType.dart';
import 'package:rrule/src/FreqStrategy.dart';
import 'package:rrule/src/Mixins/RulePartMixins.dart';

class DailyStrategy extends FreqStrategy with ByMonth, ByMonthDay, ByDay {
  List<int> byMonth, byMonthDay, byDay;

  DailyStrategy(rulePartMap, startTime, endTime)
      : super(
            rulePartMap: rulePartMap,
            startTime: startTime,
            endTime: endTime,
            ruleType: FreqType.FREQ_DAILY) {
    byMonth = getByMonth();
    byMonthDay = getByMonthDay();
    byDay = getByDay();
  }

  @override
  getDates(DateTime until) {
    // TODO: implement getDates
    throw UnimplementedError();
  }

  @override
  bool checkStatusOnDate(DateTime inputDate) {
    if (inputDate.difference(startTime).isNegative) {
      logger.i("inputDate is before the startTime");
      return false;
    }

    // step1: RulePartLogic
    if (!dailyRulePartLogic(inputDate)) {
      return false;
    }
    // step2: Until/Count logic (With interval logic)
    if (repeatType.index == RepeatType.UNTIL.index &&
        until.compareTo(inputDate) < 0) {
      logger.d("InputDate does not fall under the until interval");
      logger.e(until.toString() + "\n" + inputDate.toString());
      return false;
    } else if (repeatType.index == RepeatType.COUNT.index &&
        !dailyCountLogic(inputDate)) {
      return false;
    }
    return true;
  }

  bool dailyRulePartLogic(inputDate) {
    if (checkByMonth(byMonth, inputDate) &&
        checkByMonthDay(byMonthDay, inputDate) &&
        checkByDay(byDay, inputDate)) {
      return true;
    }
    return false;
  }

  // TODO: More efficient logic
  bool dailyCountLogic(inputDate) {
    // begin from the start date
    // keep on iterating and increment count
    // for each date that satisfies rulePart Logic
    int counter = 0;
    DateTime dateIterator = startTime.toUtc();
    // match the time of startTime (for accuracy)
    inputDate = inputDate.add(Duration(
        hours: startTime.hour,
        minutes: startTime.minute,
        seconds: startTime.second,
        microseconds: startTime.microsecond,
        milliseconds: startTime.millisecond));
    logger.i(
        "start: ${startTime.toUtc()} , input: ${inputDate.toUtc()}, counts: $count ");
    // while dateIterator is at time smaller than inputDate
    while (dateIterator.difference(inputDate).isNegative) {
      print(dateIterator.difference(inputDate).toString());
      if (dailyRulePartLogic(dateIterator)) {
        counter++;
      }
      dateIterator =
          dateIterator.add(Duration(days: interval)); // increase by interval
      if (counter > count) {
        logger
            .d("Input date exceeds the event count limit from the start date");
        return false;
      }
    }
    logger.i(" counter: $counter , totalCounts: $count");
    logger.d("The counter is smaller than count, so the event is still valid ");
    return true;
  }

  @override
  FreqType getRuleType() {
    return ruleType;
  }

  @override
  String toString() {
    return super.toString() +
        '\nDailyStrategy{byMonth: $byMonth, byMonthDay: $byMonthDay, byDay: $byDay}';
  }
}

import 'package:rrule/src/ENUMS/FreqType.dart';
import 'package:rrule/src/Enums/RepeatType.dart';
import 'package:rrule/src/FreqStrategy.dart';
import 'package:rrule/src/Mixins/RulePartMixins.dart';

class WeeklyStrategy extends FreqStrategy with ByMonth, ByDay {
  List<int> byMonth, byDay;

  WeeklyStrategy(rulePartMap, startTime, endTime)
      : super(
            rulePartMap: rulePartMap,
            startTime: startTime,
            endTime: endTime,
            ruleType: FreqType.FREQ_WEEKLY) {
    byMonth = getByMonth();
    byDay = getByDay();
  }

  @override
  getEventDates({DateTime upUntil, DateTime fromTime}) {
    // TODO: implement getDates
    throw UnimplementedError();
  }

  @override
  bool checkStatusOnDate(DateTime inputDate) {
    if (!validInputDate(inputDate)) {
      logger.i("inputDate is before the startTime");
      return false;
    }

    // step1: check the rulePart logic
    if (!weeklyRulePartLogic(inputDate)) {
      return false;
    }
    // step2: Until/Count logic (With interval logic)
    if (repeatType.index == RepeatType.UNTIL.index &&
        until.compareTo(inputDate) < 0) {
      logger.d("InputDate does not fall under the until interval");
      logger.d(until.toString() + "\n" + inputDate.toString());
      return false;
    } else if (repeatType.index == RepeatType.COUNT.index &&
        !weeklyCountLogic(inputDate)) {
      return false;
    }
    return true;
    return true;
  }

  @override
  FreqType getRuleType() {
    return ruleType;
  }

  bool weeklyRulePartLogic(inputDate) {
    if (checkByMonth(byMonth, inputDate) && checkByDay(byDay, inputDate)) {
      return true;
    }
    return false;
  }

  bool weeklyCountLogic(DateTime inputDate) {
    // begin from the start date
    // keep on iterating and increment count
    // for each date that satisfies rulePart Logic
    int counter = 0;
    DateTime dateIterator = startTime.toUtc();
    // match the Time of startTime
    inputDate = copyTimeOnly(from: startTime, to: inputDate);

    logger.i(
        "start: ${startTime.toUtc()} , input: ${inputDate.toUtc()}, counts: $count ");
    // while dateIterator is at time smaller than inputDate
    logger.d("Date Logs");
    while (dateIterator.difference(inputDate).isNegative) {
      if (weeklyRulePartLogic(dateIterator)) {
        counter++;
      }
      dateIterator = weeklyIncrementLogic(dateIterator); // increase by interval
      logger.e(dateIterator.toUtc());
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

  //TODO: Add a logic to increment interval based on other rule-part [later]
  DateTime weeklyIncrementLogic(DateTime dateTime) {
    if (byDay == null) {
      return dateTime.add(Duration(days: 7*interval));
    } else {
      // increment by 1 (it could be any day of the week)
      return dateTime.add(Duration(days: 1));
    }
  }
}

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
  getByDay() {
    // if byDay is empty, use the day of the startDate
    List<int> monthList = super.getByDay();
    monthList?.sort();
    return monthList ?? [startTime.weekday];
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
  List<DateTime> getEventDates({DateTime upUntil, DateTime fromTime}) {
    var start = fromTime;
    if (start == null ||
        !validInputDate(start) ||
        repeatType.index == RepeatType.COUNT.index) {
      start = startTime; // optional fromTime (Default: startTime)
    }
    List<DateTime> dates = [];
    // check if the upUntil date is before start
    if (upUntil.difference(start).isNegative) {
      logger.i("upUntil is before the startTime");
      return dates;
    }

    upUntil = copyTimeOnly(from: start, to: upUntil);
    DateTime dateIterator = start.toUtc();

    if (repeatType.index == RepeatType.COUNT.index) {
      int counter = 0;
      while (dateIterator.difference(upUntil).isNegative && counter < count) {
        if (weeklyRulePartLogic(dateIterator)) {
          if (start == dateIterator ||
              start.difference(dateIterator).isNegative) {
            dates.add(dateIterator);
          }
          counter++;
        }
        dateIterator = weeklyIncrementLogic(dateIterator);
      }
    } else {
      // if Event-Until is smaller than passed argument upUntil Date
      if (until != null && until.difference(until).isNegative) {
        upUntil = until;
      }
      while (dateIterator.difference(upUntil).isNegative) {
        if (checkStatusOnDate(dateIterator)) {
          dates.add(dateIterator);
        }
        dateIterator = weeklyIncrementLogic(dateIterator);
      }
    }

    return dates;
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
    inputDate = copyTimeOnly(from: startTime.toUtc(), to: inputDate.toUtc());

    logger.i(
        "start: ${startTime.toUtc()} , input: ${inputDate.toUtc()}, counts: $count ");
    // while dateIterator is at time smaller than inputDate
    while (dateIterator.difference(inputDate).isNegative) {
      if (weeklyRulePartLogic(dateIterator)) {
        counter++;
      }
      dateIterator = weeklyIncrementLogic(dateIterator); // increase by interval

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
      return dateTime.add(Duration(days: 7 * interval));
    } else {
      // skip a interval * weeks and start from begin of the next week
      var incrementDays = 1;
      if (dateTime.weekday == byDay.last) {
        // increment to first day of next week
        incrementDays = (7 - dateTime.weekday) + (7 * (interval - 1));
      }
      return dateTime.add(Duration(days: incrementDays));
    }
  }
}

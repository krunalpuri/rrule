import 'package:rrule/src/Enums/FreqType.dart';
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

  // overrides getByDay() from FreqStrategy abstract class
  @override
  List<int> getByDay() {
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
      logger.d("InputDate does not fall under the until interval \n" +
          until.toString() +
          "\n" +
          inputDate.toString());
      return false;
    } else if(!checkIntervalLogic(inputDate)){
      return false;
    }
    else if (repeatType.index == RepeatType.COUNT.index &&
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
      if (until != null && until.difference(upUntil).isNegative) {
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
      // skip an interval * weeks and start from begin of the next week
      var incrementDays = 1;
      if (dateTime.weekday == byDay.last) {
        // increment to first day of next week
        incrementDays = (7 - dateTime.weekday) + (7 * (interval - 1));
      }
      return dateTime.add(Duration(days: incrementDays));
    }
  }

  bool checkIntervalLogic(DateTime inputDate) {
    if(interval > 1) {
      // get the weekday of inputDate as inputWeekDay and
      // find the next weekday after startDate that matches inputWeekDay
      int nextWeekDay ;
      if( (startTime.weekday - inputDate.weekday) <= 0){
          nextWeekDay =  (inputDate.weekday - startTime.weekday);
      }
      else{
        nextWeekDay =  7 - (startTime.weekday - inputDate.weekday);
      }

      DateTime beginTime = startTime.add(Duration(days: nextWeekDay));
      int difference = beginTime
          .difference(inputDate)
          .inDays;

      return (difference % (7 * interval) == 0);
    }
    return true;
  }

}

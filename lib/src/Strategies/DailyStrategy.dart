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

  @override
  List<DateTime> getEventDates({DateTime upUntil, DateTime fromTime}) {
    if(fromTime == null || fromTime.difference(startTime).isNegative) {
      fromTime = startTime; // optional from
    }
    List<DateTime> dates = [];
    // check if the upUntil date is before from
    if (upUntil.difference(fromTime).isNegative) {
      logger.i("inputDate is before the startTime");
      return dates;
    }

    upUntil = copyTimeOnly(from: fromTime, to: upUntil);
    DateTime dateIterator = fromTime.toUtc();

    if (repeatType.index == RepeatType.COUNT.index) {
      int counter = 0;
      while (dateIterator.difference(upUntil).isNegative && counter<count) {
        if (dailyRulePartLogic(dateIterator)) {
          dates.add(dateIterator);
          counter++;
        }
        dateIterator = incrementLogic(dateIterator);
      }
    }
    // forever and until repetition
    else {
      // if Event-Until is small than function's upUntil Date
      if (until != null && until.difference(until).isNegative) {
        upUntil = until;
      }
      while (dateIterator.difference(upUntil).isNegative) {
        if (checkStatusOnDate(dateIterator)) {
          dates.add(dateIterator);
        }

        dateIterator = incrementLogic(dateIterator);
      }
    }

    return dates;
  }

  //TODO: Add a logic to increment interval based on other rule-part [later]
  DateTime incrementLogic(DateTime dateTime){
    return dateTime.add(Duration(days: interval));

  }

  bool dailyRulePartLogic(inputDate) {
    if (checkByMonth(byMonth, inputDate) &&
        checkByMonthDay(byMonthDay, inputDate) &&
        checkByDay(byDay, inputDate)) {
      return true;
    }
    return false;
  }

  // TODO: More efficient logic [later]
  bool dailyCountLogic(inputDate) {
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
    while (dateIterator.difference(inputDate).isNegative) {
      if (dailyRulePartLogic(dateIterator)) {
        counter++;
      }
      dateIterator = incrementLogic(dateIterator);// increase by interval
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

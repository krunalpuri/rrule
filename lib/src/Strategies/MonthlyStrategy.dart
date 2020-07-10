import 'package:rrule/src/Enums/FreqType.dart';
import 'package:rrule/src/Enums/RepeatType.dart';
import 'package:rrule/src/FreqStrategy.dart';
import 'package:rrule/src/Helpers/WeekDays2Code.dart';
import 'package:rrule/src/Mixins/RulePartMixins.dart';


// IMP: MONTHLY Override BYDAY
// Should be handled differently

// Three RuleParts in this order: [ByMonth -> ByMonthDay -> ByDay]
// For Each Year
// Get all the months (Filter by BYMonth
// For each month: Find all byDays values (EX: -1SU => Last sunday of the month)
//

class MonthlyStrategy extends FreqStrategy with ByMonth, ByMonthDay, ByDay, ByDayExpand{
  List<int> byMonth, byMonthDay, byDay;
  List<String> byDayExpand = []; // if byDay expands the range of dates

  MonthlyStrategy(rulePartMap, startTime, endTime)
      : super(
            rulePartMap: rulePartMap,
            startTime: startTime,
            endTime: endTime,
            ruleType: FreqType.FREQ_MONTHLY){
    byMonth = getByMonth();
    byMonthDay = getByMonthDay();
    byDay = getByDay();
  }

  // overrides getByDay() from FreqStrategy abstract class
  @override
  List<int> getByDay() {
    if (rulePartMap.containsKey("BYDAY")) {
      logger.d("Monthly Strategy: BYDAY FOUND");
      //      The BYDAY rule part specifies a COMMA-separated list of days of
      //      the week; SU indicates Sunday; MO indicates Monday; TU indicates
      //      Tuesday; WE indicates Wednesday; TH indicates Thursday; FR
      //      indicates Friday; and SA indicates Saturday.
      //
      //      Each BYDAY value can also be preceded by a positive (+n) or
      //      negative (-n) integer.  If present, this indicates the nth
      //      occurrence of a specific day within the MONTHLY or YEARLY "RRULE".
      List<String> weekdaysCode = rulePartMap["BYDAY"].split(",");
      logger.d(weekdaysCode.toString());
      // For each getByDay value evaluate if it contains weekday or monthday value
      List<int> weekDays = weekdaysCode.map(monthlyByDayEvaluation).toList();
      return weekDays;
    }
    return null;
  }

  int monthlyByDayEvaluation(String input) {
    if(input.length > 2){
      // Ex +1MO or -1MO
      // this means its a month day value and expands the list of possible days
      // hence they it's added to the list of byDateExpand handled by custom rule called
      // byDayExpand (which checks if the inputdate falls on a given day of it's month)
      // and then finally returns the weekday for ByDay rule
      byDayExpand.add(input);
      return convertWeekdaysToInt(onlyAlphabets(input));
    }
    else{
      // normal weekday value  SU,MO,TU
      return convertWeekdaysToInt(input);
    }
  }

  // TODO: Change the logic [later]
  @override
  getEventDates({DateTime upUntil, DateTime fromTime}) {
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
        if (monthlyRulePartLogic(dateIterator)) {
          if (start == dateIterator ||
              start.difference(dateIterator).isNegative) {
            dates.add(dateIterator);
          }
          counter++;
        }
        dateIterator = monthlyIncrementLogic(dateIterator);
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
        dateIterator = monthlyIncrementLogic(dateIterator);
      }
    }
    return dates;
  }

  DateTime monthlyIncrementLogic(DateTime dateTime) {
    if (byDay == null) {
      return new DateTime(dateTime.year, dateTime.month + (1 * interval), dateTime.day);
    } else {
      var incrementDays;
      if (dateTime.weekday == byDay.last) {
        // increment to first day of next week
        incrementDays = (7 - dateTime.weekday);
      }
      if(incrementDays == null || incrementDays <= 0){
        incrementDays = 1;
      }

      DateTime nextDate = dateTime.add(Duration(days: incrementDays));
      // skip months based on interval
      if( nextDate.month != dateTime.month && interval > 1){
        nextDate = new DateTime(dateTime.year, dateTime.month + interval, 1);
      }
      return nextDate;
    }
  }

  @override
  bool checkStatusOnDate(DateTime dateTime) {
    if (!validInputDate(dateTime)) {
      return false;
    }

    // step1: RulePartLogic
    if (!monthlyRulePartLogic(dateTime)) {
      return false;
    }

    return true;
  }

  @override
  FreqType getRuleType() {
    return ruleType;
  }

  bool monthlyRulePartLogic(inputDate) {
    if (checkByMonth(byMonth, inputDate) &&
        checkMonthlyInterval(interval, inputDate) &&
        checkByMonthDay(byMonthDay, inputDate) &&
        checkByDay(byDay, inputDate) &&
        checkByDayExpand(byDayExpand, inputDate)) {
      return true;
    }
    return false;
  }

  bool checkMonthlyInterval(int interval, DateTime inputDate){
    int diffMonth = (inputDate.year - startTime.year) * 12 + (inputDate.month - startTime.month).abs();
    return (diffMonth % interval != 0) ? false : true;
  }


  
}

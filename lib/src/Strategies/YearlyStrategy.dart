import 'package:rrule/src/Enums/FreqType.dart';
import 'package:rrule/src/Enums/RepeatType.dart';
import 'package:rrule/src/FreqStrategy.dart';
import 'package:rrule/src/Helpers/WeekDays2Code.dart';
import 'package:rrule/src/Mixins/RulePartMixins.dart';

// Yearly: ByDay is different than Monthly.
// ByDay: 20MO means 20th Monday of the year

class YearlyStrategy extends FreqStrategy with ByMonth, ByMonthDay, ByDay, ByDayExpand{
  List<int> byMonth, byMonthDay, byDay, byWeekNo, byYearDay;
  List<String> byDayExpand = []; // if byDay expands the range of dates
  YearlyStrategy(rulePartMap, startTime, endTime)
      : super(
            rulePartMap: rulePartMap,
            startTime: startTime,
            endTime: endTime,
            ruleType: FreqType.FREQ_YEARLY){
    byDay = getByDay();
    byMonth = getByMonth();
    byMonthDay = getByMonthDay();
    // TODO: getByWeekNo and getByYearDay
  }

  @override
  List<int> getByMonth(){
    List<int> byMonth = super.getByMonth();
    // if there is no byMonth, take the month of startTime
    if((byMonth == null || byMonth.isEmpty) && byDay == null){
      byMonth = [];
      byMonth.add(startTime.month);
    }
    return byMonth;
  }

  @override
  List<int> getByMonthDay() {
    List<int> byMonthDay = super.getByMonthDay();
    // if there is no byMonth, take the month day of startTime
    if((byMonthDay == null || byMonthDay.isEmpty) && byDay == null){
      byMonthDay = [];
      byMonthDay.add(startTime.day);
    }
    return byMonthDay;
  }

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
    bool validDate = false;
    if (repeatType.index == RepeatType.COUNT.index) {
      int counter = 0;
      while (dateIterator.difference(upUntil).isNegative && counter < count) {
        if (checkStatusOnDate(dateIterator)) {
          if (start == dateIterator ||
              start.difference(dateIterator).isNegative) {
            dates.add(dateIterator);
            validDate = true;
          }else{
            validDate = false;
          }
          counter++;
        }
        dateIterator = yearlyIncrementLogic(dateIterator,validDate);
      }
    } else {
      // if Event-Until is smaller than passed argument upUntil Date
      if (until != null && until.difference(upUntil).isNegative) {
        upUntil = until;
      }
      while (dateIterator.difference(upUntil.add(Duration(minutes: 1))).isNegative) {
        if (checkStatusOnDate(dateIterator)) {
          dates.add(dateIterator);
          validDate = true;
        }else{
          validDate = false;
        }
        dateIterator = yearlyIncrementLogic(dateIterator,validDate);
      }
    }
    return dates;
  }

  @override
  bool checkStatusOnDate(DateTime inputDate) {
    if (!validInputDate(inputDate)) {
      return false;
    }

    // step1: RulePartLogic
    if (!yearlyRulePartLogic(inputDate)) {
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
        !yearlyCountLogic(inputDate)) {
      return false;
    }
    return true;

    return true;
  }

  @override
  FreqType getRuleType() {
    return ruleType;
  }

  bool yearlyRulePartLogic(DateTime inputDate) {
//    print("checkByMonth: " +checkByMonth(byMonth, inputDate).toString());
//    print("checkByMonthDay: " +checkByMonthDay(byMonthDay, inputDate).toString());
//    print("checkByDay: " +checkByDay(byDay, inputDate).toString());
//    print("checkYear: " +checkYear(inputDate).toString());
//    print("checkByDayExpand: " +checkByDayExpand(byDayExpand, inputDate,strategy: "Yearly").toString());

//    logger.i("checkByMonth: " +checkByMonth(byMonth, inputDate).toString());
//    logger.i("checkByMonthDay: " +checkByMonthDay(byMonthDay, inputDate).toString());
//    logger.i("checkByDay: " +checkByDay(byDay, inputDate).toString());
//    logger.i("checkYear: " +checkYear(inputDate).toString());
//    logger.i("checkByDayExpand: " +checkByDayExpand(byDayExpand, inputDate,strategy: "Yearly").toString());


    if (checkByMonth(byMonth, inputDate) &&
        checkByYearDay(byYearDay, inputDate) &&
        checkByWeekNo(byWeekNo, inputDate) &&
        checkByMonthDay(byMonthDay, inputDate) &&
        checkByDay(byDay, inputDate) &&
        checkByDayExpand(byDayExpand, inputDate,strategy: "Yearly")
    ) {
      return true;
    }
    return false;
  }

  // overrides getByDay() from FreqStrategy abstract class
  @override
  List<int> getByDay() {
    if (rulePartMap.containsKey("BYDAY")) {
      logger.d("Monthly Strategy: BYDAY FOUND");
      //      The BYDAY rule part specifies a COMMA-separated list of days of
      //      the week; SU, MO,.... so on.
      //      Each BYDAY value can also be preceded by a positive (+n) or
      //      negative (-n) integer.  If present, this indicates the nth
      //      occurrence of a specific day within the MONTHLY or YEARLY "RRULE".
      List<String> weekdaysCode = rulePartMap["BYDAY"].split(",");
      logger.d(weekdaysCode.toString());
      // For each getByDay value evaluate if it contains weekday or monthday value
      List<int> weekDays = weekdaysCode.map(yearlyByDayEvaluation).toList();
      return weekDays;
    }
    return null;
  }

  int yearlyByDayEvaluation(String input) {
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

  bool checkByYearDay(List<int> byYearDay, DateTime inputDate) {
    // TODO: LATER
    return true;
  }

  bool checkByWeekNo(List<int> byWeekNo, DateTime inputDate) {
    // TODO: LATER
    return true;
  }

  DateTime yearlyIncrementLogic(DateTime dateTime, bool validDate) {
    var incrementDays = 1;
    if (byDay != null && dateTime.weekday == byDay.last && ByMonthDay == null) {
      // increment to first day of next week
      incrementDays = (365 - dateTime.weekday);
    }
    if((incrementDays == null || incrementDays <= 0) || !validDate){
      incrementDays = 1;
    }

    DateTime nextDate = dateTime.add(Duration(days: incrementDays));
    return nextDate;
  }

  bool checkIntervalLogic(DateTime inputDate){
    int diffYear = (inputDate.year - startTime.year);
//    print( inputDate.toString() + " \n " + diffMonth.toString() );
    return (diffYear % interval != 0) ? false : true;
  }

  bool yearlyCountLogic(DateTime inputDate) {
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
    bool validDate = false;
    while (dateIterator.difference(inputDate.add(Duration(minutes: 1))).isNegative) {
      if (yearlyRulePartLogic(dateIterator) && checkIntervalLogic(dateIterator)) {
        counter++;
        validDate = true;
      }else{
        validDate = false;
      }
      dateIterator = yearlyIncrementLogic(dateIterator,validDate); // increase by interval

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
}

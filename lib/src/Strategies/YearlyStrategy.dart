import 'package:rrule/src/ENUMS/FreqType.dart';
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
    // TODO: implement getDates
    throw UnimplementedError();
  }

  @override
  bool checkStatusOnDate(DateTime dateTime) {
    if (!validInputDate(dateTime)) {
      return false;
    }

    // step1: RulePartLogic
    if (!yearlyRulePartLogic(dateTime)) {
      return false;
    }

    return true;
  }

  @override
  FreqType getRuleType() {
    return ruleType;
  }

  bool yearlyRulePartLogic(DateTime inputDate) {

    logger.i("checkByMonth: " +checkByMonth(byMonth, inputDate).toString());
    logger.i("checkByMonthDay: " +checkByMonthDay(byMonthDay, inputDate).toString());
    logger.i("checkByDay: " +checkByDay(byDay, inputDate).toString());
    logger.i("checkByDayExpand: " +checkByDayExpand(byDayExpand, inputDate).toString());
    logger.i("checkYear: " +checkYear(inputDate).toString());
    logger.i("checkByDayExpand: " +checkByDayExpand(byDayExpand, inputDate,strategy: "Yearly").toString());


    if (checkYear(inputDate) &&
        checkByMonth(byMonth, inputDate) &&
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

  bool checkYear(DateTime inputDate) {
    // check if year falls under the interval
    int diff = (inputDate.year - startTime.year);
    if(diff < 0 || diff%interval != 0 ){
      return false;
    }
    if(interval > 1 && diff%interval != 0 ){
      return false;
    }

    // make sure the until/ count are satisfied
    if (repeatType.index == RepeatType.COUNT.index) {
      // TODO: LATER
      // For each year, we have to find the count of valid dates, until the inputDate
      return true;
    }
    else{
      // check if until date of the event is before or after the inputDate
      if(until != null) {
        return (!until
            .difference(inputDate)
            .isNegative);
      }
      else{
        return true;
      }
    }
  }



}

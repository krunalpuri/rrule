import 'package:rrule/src/ENUMS/FreqType.dart';
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
      return convertWeekdaysToInt(input.trim().substring(1,3));
    }
    else{
      // normal weekday value  SU,MO,TU
      return convertWeekdaysToInt(input);
    }
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
//    logger.i( "By Month" + checkByMonth(byMonth, inputDate).toString());
//    logger.i("By MonthDay" + checkByMonthDay(byMonthDay, inputDate).toString());
//    logger.i("By Day" + checkByDay(byDay, inputDate).toString());
//    logger.i("By Day Expand" + checkByDayExpand(byDayExpand, inputDate).toString());

    if (checkByMonth(byMonth, inputDate) &&
        checkByMonthDay(byMonthDay, inputDate) &&
        checkByDay(byDay, inputDate) &&
        checkByDayExpand(byDayExpand, inputDate)) {
      return true;
    }
    return false;
  }


  
}

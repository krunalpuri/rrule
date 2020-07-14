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
    byDay = getByDay();
    byMonth = getByMonth();
    byMonthDay = getByMonthDay();

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
      weekDays?.sort();
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

  // TODO: Change this logic [later]
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
        dateIterator = monthlyIncrementLogic(dateIterator,validDate);
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
        dateIterator = monthlyIncrementLogic(dateIterator,validDate);
      }
    }
    return dates;
  }

  DateTime monthlyIncrementLogic(DateTime dateTime, bool validDate) {
      var incrementDays = 1;
      if (byDay != null && dateTime.weekday == byDay.last) {
        // increment to first day of next week
        incrementDays = (7 - dateTime.weekday);
      }
      if((incrementDays == null || incrementDays <= 0) || !validDate){
        incrementDays = 1;
      }

      DateTime nextDate = dateTime.add(Duration(days: incrementDays));
      return nextDate;
  }

  @override
  bool checkStatusOnDate(DateTime inputDate) {
    if (!validInputDate(inputDate)) {
      return false;
    }

    // step1: RulePartLogic
    if (!monthlyRulePartLogic(inputDate)) {
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
        !monthlyCountLogic(inputDate)) {
      return false;
    }
    return true;

  }

  @override
  FreqType getRuleType() {
    return ruleType;
  }

  bool monthlyRulePartLogic(inputDate) {
//    print(inputDate);
//    print(checkByMonth(byMonth, inputDate));
//    print(checkByMonthDay(byMonthDay, inputDate));
//    print(checkByDay(byDay, inputDate));
//    print(checkByDayExpand(byDayExpand, inputDate));

    if (checkByMonth(byMonth, inputDate) &&
        checkByMonthDay(byMonthDay, inputDate) &&
        checkByDay(byDay, inputDate) &&
        checkByDayExpand(byDayExpand, inputDate)) {
      return true;
    }
    return false;
  }

  bool checkIntervalLogic(DateTime inputDate){
    int diffMonth = (inputDate.year - startTime.year) * 12 + (inputDate.month - startTime.month);
//    print( inputDate.toString() + " \n " + diffMonth.toString() );
    return (diffMonth % interval != 0) ? false : true;
  }

  bool monthlyCountLogic(DateTime inputDate) {
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
      if (monthlyRulePartLogic(dateIterator) && checkIntervalLogic(dateIterator)) {
        counter++;
        validDate = true;
      }else{
        validDate = false;
      }
      dateIterator = monthlyIncrementLogic(dateIterator,validDate); // increase by interval

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

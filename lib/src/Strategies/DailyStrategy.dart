import 'package:rrule/src/ENUMS/FreqType.dart';
import 'package:rrule/src/Enums/RepeatType.dart';
import 'package:rrule/src/FreqStrategy.dart';
import 'package:rrule/src/Mixins/RulePartMixins.dart';

class DailyStrategy extends FreqStrategy with ByMonth,ByMonthDay,ByDay {
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
    // check if the inputDate is before the end of repeat date
    // Here the 'interval' field can be checked first, to avoid unnecessary
    // computation, because all the rule-type are LIMIT behavior on recurrence.
    // (Check the table iCalender specification)

    if(repeatType.index == RepeatType.UNTIL.index){
      if(until.compareTo(inputDate) < 0){
        logger.d("The input date isbefore");
        logger.e(until.toString() + "\n" + inputDate.toString());
        return false;
      }
    }
    if(!checkByMonth(byMonth, inputDate)){
      return false;
    }

    if(!checkByMonthDay(byMonthDay, inputDate)){
      return false;
    }

    if(!checkByDay(byDay, inputDate)){
      return false;
    }

    if(repeatType.index == RepeatType.COUNT.index){
      // TODO: Logic to check if the count
      
    }

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

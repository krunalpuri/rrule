import 'package:rrule/src/ENUMS/FreqType.dart';
import 'package:rrule/src/FreqStrategy.dart';

class MonthlyStrategy extends FreqStrategy {
  MonthlyStrategy(rulePartMap, startTime, endTime)
      : super(
            rulePartMap: rulePartMap,
            startTime: startTime,
            endTime: endTime,
            ruleType: FreqType.FREQ_MONTHLY);

  @override
  getEventDates({DateTime upUntil, DateTime fromTime}) {
    // TODO: implement getDates
    throw UnimplementedError();
  }

  @override
  bool checkStatusOnDate(DateTime dateTime) {
    // TODO: implement isEventPlanned
    throw UnimplementedError();
  }

  @override
  FreqType getRuleType() {
    return ruleType;
  }

}

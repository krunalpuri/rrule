import 'package:rrule/src/ENUMS/FreqType.dart';
import 'package:rrule/src/FreqStrategy.dart';

class WeeklyStrategy extends FreqStrategy {
  WeeklyStrategy(rulePartMap, startTime, endTime)
      : super(
            rulePartMap: rulePartMap,
            startTime: startTime,
            endTime: endTime,
            ruleType: FreqType.FREQ_WEEKLY);

  @override
  getDates(DateTime until) {
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

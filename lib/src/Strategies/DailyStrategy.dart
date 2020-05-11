import 'package:rrule/src/ENUMS/FreqType.dart';
import 'package:rrule/src/FreqStrategy.dart';

class DailyStrategy extends FreqStrategy {

  DailyStrategy(rulePartMap, startTime, endTime)
      : super(
            rulePartMap: rulePartMap,
            startTime: startTime,
            endTime: endTime,
            ruleType: FreqType.FREQ_DAILY);

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

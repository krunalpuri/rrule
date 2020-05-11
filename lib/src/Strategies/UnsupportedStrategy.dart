import 'package:rrule/src/ENUMS/FreqType.dart';
import 'package:rrule/src/FreqStrategy.dart';

class UnsupportedStrategy extends FreqStrategy {
  UnsupportedStrategy(rulePartMap, startTime, endTime)
      : super(
            rulePartMap: rulePartMap,
            startTime: startTime,
            endTime: endTime,
            ruleType: FreqType.FREQ_UNSUPPORTED);

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

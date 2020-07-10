import 'package:rrule/src/Enums/FreqType.dart';
import 'package:rrule/src/FreqStrategy.dart';

class UnsupportedStrategy extends FreqStrategy {
  UnsupportedStrategy(rulePartMap, startTime, endTime)
      : super(
            rulePartMap: rulePartMap,
            startTime: startTime,
            endTime: endTime,
            ruleType: FreqType.FREQ_UNSUPPORTED);

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

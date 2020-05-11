import 'package:logger/logger.dart';
import 'package:rrule/src/ENUMS/RepeatType.dart';

import 'ENUMS/FreqType.dart';

final logger = Logger();

abstract class FreqStrategy {
  final rulePartMap;
  final DateTime startTime, endTime;
  final FreqType ruleType;
  int interval = 1;
  int count;
  DateTime until;
  RepeatType repeatType = RepeatType.FOREVER;

  FreqStrategy(
      {this.rulePartMap,
      this.startTime,
      this.endTime,
      this.ruleType = FreqType.FREQ_UNSUPPORTED}) {
    getRepeatTypeAndDuration();
  }

  List<DateTime> getDates(DateTime until);

  bool checkStatusOnDate(DateTime dateTime);

  FreqType getRuleType();

  void getRepeatTypeAndDuration() {
    if (rulePartMap.containsKey("INTERVAL")) {
      logger.d("INTERVAL FOUND");
      interval = rulePartMap["INTERVAL"];
    }
    if (rulePartMap.containsKey("COUNT")) {
      logger.d("COUNT FOUND");
      count = rulePartMap["COUNT"];
      repeatType = RepeatType.UNTIL;
    } else if (rulePartMap.containsKey("UNTIL")) {
      logger.d("UNTIL FOUND");
      until = DateTime.parse(rulePartMap["UNTIL"]);
      repeatType = RepeatType.UNTIL;
    }
  }

  @override
  String toString() {
    return 'FreqStrategy{rulePartMap: $rulePartMap, startTime: $startTime, endTime: $endTime, ruleType: $ruleType, interval: $interval, count: $count, until: $until, repeatType: $repeatType}';
  }
}

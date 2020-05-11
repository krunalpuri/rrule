import 'dart:core';
import 'package:logger/logger.dart';
import 'package:rrule/src/FreqStrategy.dart';
import 'package:rrule/src/FreqStrategyFactory.dart';
import 'ENUMS/FreqType.dart';

final logger = Logger();

class RRuleParse {
  final List<String> recurrence;
  DateTime startTime, endTime;
  FreqStrategy freqStrategy;

  RRuleParse.googleEvent({this.recurrence, this.startTime, this.endTime});

  String test() {
    return "TEST RRULE: ${recurrence.first} ; Length: ${recurrence.length}";
  }

  FreqType parseRule() {
    try {
      String rrule = recurrence?.first;
      rrule = rrule.replaceFirst('RRULE:', '');
      if (rrule == null || rrule.isEmpty) {
        throw Exception("Please pass a valid rrule");
      }
      final rulePartList = rrule.split(";");
      var rulePartMap = Map.fromIterable(rulePartList,
          key: (e) => e.split('=')[0], value: (e) => e.split('=')[1]);

      rulePartMap.forEach((key, value) {
        print("$key $value");
      });

      if (!rulePartMap.containsKey("FREQ")) {
        throw Error();
      }

      freqStrategy = FreqStrategyFactory.getFreqStrategy(
          rulePartMap: rulePartMap, startTime: startTime, endTime: endTime);
      return freqStrategy?.ruleType;
    } catch (e) {
      logger.d(e.toString());
    }
  }
}

void main() {
  Logger.level = Level.debug;

  List<String> recurrence = [
    "RRULE:FREQ=DAILY;UNTIL=20200523T035959Z;BYDAY=SU,MO,TU"
  ];
  RRuleParse rRuleParse = RRuleParse.googleEvent(
      recurrence: recurrence, startTime: null, endTime: null);
  logger.d(rRuleParse.parseRule());
  logger.d(rRuleParse.freqStrategy.toString());
}

//  List<String> recurrence = ["RRULE:FREQ=DAILY"];
//  List<String> recurrence = ["RRULE:FREQ=DAILY;UNTIL=20200523T035959Z"];
//  List<String> recurrence = ["RRULE:FREQ=WEEKLY;BYDAY=FR"];
//  List<String> recurrence = ["RRULE:FREQ=YEARLY"];

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
  Logger.level = Level.info;

  DateTime start = DateTime.now().add(Duration(days: -20));
  logger.i(start);
  List<String> recurrence = [
    "RRULE:FREQ=DAILY;COUNT=100;BYDAY=FR,TU"
//    "RRULE:FREQ=DAILY;UNTIL=20200523T035959Z;BYDAY=SU,MO,TU,SA"
  ];
  RRuleParse rRuleParse = RRuleParse.googleEvent(
      recurrence: recurrence, startTime: start, endTime: null);

  logger.d(rRuleParse.parseRule());
  logger.d(rRuleParse.freqStrategy.toString());

  DateTime testStartDate = DateTime(2020, 05, 01).toUtc();
  DateTime testDate = DateTime(2020, 05, 31).toUtc();
  logger.i("testDate: $testDate");

  logger.d(rRuleParse.freqStrategy.checkStatusOnDate(testDate));
  rRuleParse.freqStrategy.getEventDates(fromTime: testStartDate, upUntil: testDate).forEach((element) {
    print("${element.toUtc()}, ${element.weekday}");
  });
}

//  List<String> recurrence = ["RRULE:FREQ=DAILY"];
//  List<String> recurrence = ["RRULE:FREQ=DAILY;UNTIL=20200523T035959Z"];
//  List<String> recurrence = ["RRULE:FREQ=WEEKLY;BYDAY=FR"];
//  List<String> recurrence = ["RRULE:FREQ=YEARLY"];
//    "RRULE:FREQ=DAILY;UNTIL=20200523T035959Z;BYDAY=SU,MO,TU;BYMONTHDAY=-2,15"

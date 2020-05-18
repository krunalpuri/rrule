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

      logger.i(rulePartMap.toString());
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

  List<DateTime> getEventDates({DateTime fromDate, DateTime toDate}) {
    try {
      assert(toDate != null);
      return freqStrategy.getEventDates(fromTime: fromDate, upUntil: toDate);
    } catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  bool checkEventStatusOn(DateTime dateTime) {
    return freqStrategy.checkStatusOnDate(dateTime);
  }
}

void main() {
  Logger.level = Level.debug;

  DateTime start = DateTime.now().add(Duration(days: 1)).toUtc();
  logger.i("start: $start");
  List<String> recurrence = [
    "RRULE:FREQ=WEEKLY;COUNT=2"
//    "RRULE:FREQ=DAILY;UNTIL=20200523T035959Z;BYDAY=SU,MO,TU"
  ];
  RRuleParse rRuleParse = RRuleParse.googleEvent(
      recurrence: recurrence, startTime: start, endTime: null);

  logger.d(rRuleParse.parseRule());
  logger.d(rRuleParse.freqStrategy.toString());

  DateTime testStartDate = DateTime(2020, 06, 1).toUtc();
  DateTime testDate = DateTime(2020, 06, 31).toUtc();
  logger.i("testStartDate: $testStartDate, ${testStartDate.weekday}" +
      "\n" +
      "testDate: $testDate, ${testDate.weekday}");

  logger.i(rRuleParse.checkEventStatusOn(testStartDate));
//  rRuleParse.getEventDates(fromDate: testStartDate, toDate: testDate).forEach((element) {
//    print("${element.toUtc()}, ${element.weekday}");
//  });
}

//  List<String> recurrence = ["RRULE:FREQ=DAILY"];
//  List<String> recurrence = ["RRULE:FREQ=DAILY;UNTIL=20200523T035959Z"];
//  List<String> recurrence = ["RRULE:FREQ=WEEKLY;BYDAY=FR"];
//  List<String> recurrence = ["RRULE:FREQ=YEARLY"];
//    "RRULE:FREQ=DAILY;UNTIL=20200523T035959Z;BYDAY=SU,MO,TU;BYMONTHDAY=-2,15"

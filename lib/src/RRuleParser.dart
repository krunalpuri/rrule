import 'dart:core';
import 'package:logger/logger.dart';
import 'package:rrule/src/FreqStrategy.dart';
import 'package:rrule/src/FreqStrategyFactory.dart';
import 'package:rrule/src/Strategies/Strategies.dart';
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

//  DateTime start = DateTime.now().add(Duration(days: 1)).toUtc();
  DateTime start = DateTime(1997, 9, 2).toUtc();
  logger.i("start: $start");
  List<String> recurrence = [
  "RRULE:FREQ=DAILY;UNTIL=20000131T140000Z;BYMONTH=1"

  ];
  RRuleParse rRuleParse = RRuleParse.googleEvent(
      recurrence: recurrence, startTime: start, endTime: null);

  logger.d(rRuleParse.parseRule());
  logger.d(rRuleParse.freqStrategy.toString());

  DateTime testFromDate = DateTime(1997, 9, 2).toUtc();
  DateTime testUntilDate = DateTime(2002, 12, 31).toUtc();
  logger.i("testFromDate: $testFromDate, ${testFromDate.weekday}" +
      "\n" +
      "testUntilDate: $testUntilDate, ${testUntilDate.weekday}");

  print(rRuleParse.checkEventStatusOn(testFromDate));
  var result = rRuleParse.getEventDates(fromDate: testFromDate, toDate: testUntilDate);
  result.forEach((element) {
    print("${element.toUtc()}, ${element.weekday}");
  });
  print(result.length);

}

// (##)DailyStrategy
//    "RRULE:FREQ=DAILY;COUNT=10"
//    "RRULE:FREQ=DAILY;UNTIL=19971224T000000Z"
//    "RRULE:FREQ=DAILY;INTERVAL=2"
//    "RRULE:FREQ=DAILY;INTERVAL=10;COUNT=5"
//    "RRULE:FREQ=DAILY;UNTIL=20000131T140000Z;BYMONTH=1"
//    "RRULE:FREQ=DAILY;UNTIL=20200523T035959Z;BYDAY=SU,MO,TU;BYMONTHDAY=-2,15"
//    "RRULE:FREQ=DAILY;UNTIL=20200523T035959Z;BYDAY=SU,MO,TU"


// (##)WeeklyStrategy
//  RRULE:FREQ=WEEKLY;UNTIL=19971224T000000Z
//  "RRULE:FREQ=WEEKLY;COUNT=10"
//  "RRULE:FREQ=WEEKLY;UNTIL=20200523T035959Z"
//  "RRULE:FREQ=WEEKLY;INTERVAL=2;WKST=SU"
//  "RRULE:FREQ=WEEKLY;COUNT=10;WKST=SU;BYDAY=TU,TH"
//  "RRULE:FREQ=WEEKLY;INTERVAL=2" //;BYDAY=SU,MO,WE"
//  "RRULE:FREQ=WEEKLY;INTERVAL=2;COUNT=8;WKST=SU;BYDAY=TU,TH"
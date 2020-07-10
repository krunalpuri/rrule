import 'dart:core';
import 'package:logger/logger.dart';
import 'package:rrule/src/FreqStrategy.dart';
import 'package:rrule/src/FreqStrategyFactory.dart';
import 'package:rrule/src/Strategies/Strategies.dart';
import 'Enums/FreqType.dart';

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
  DateTime start = DateTime(1997, 8, 1).toUtc();
  logger.i("start: $start");
  logger.i("start weekday: ${start.weekday}");
  List<String> recurrence = [
    "RRULE:FREQ=YEARLY;BYDAY=9MO"
  ];
  RRuleParse rRuleParse = RRuleParse.googleEvent(
      recurrence: recurrence, startTime: start, endTime: null);

  logger.d(rRuleParse.parseRule());
  logger.d(rRuleParse.freqStrategy.toString());

  DateTime testFromDate = DateTime(2000, 2, 28).toUtc();
  DateTime testUntilDate = DateTime(2002, 12, 31).toUtc();
  logger.i("testFromDate: $testFromDate, ${testFromDate.weekday}" +
      "\n" +
      "testUntilDate: $testUntilDate, ${testUntilDate.weekday}");

  logger.e(rRuleParse.checkEventStatusOn(testFromDate));
//  var result = rRuleParse.getEventDates(fromDate: testFromDate, toDate: testUntilDate);
//  result.forEach((element) {
//    print("${element.toUtc()}, ${element.weekday}");
//  });
//  print(result.length);

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
//  "RRULE:FREQ=WEEKLY;UNTIL=19971224T000000Z"
//  "RRULE:FREQ=WEEKLY;COUNT=10"
//  "RRULE:FREQ=WEEKLY;UNTIL=20200523T035959Z"
//  "RRULE:FREQ=WEEKLY;INTERVAL=2;WKST=SU"
//  "RRULE:FREQ=WEEKLY;COUNT=10;WKST=SU;BYDAY=TU,TH"
//  "RRULE:FREQ=WEEKLY;INTERVAL=2" //;BYDAY=SU,MO,WE"
//  "RRULE:FREQ=WEEKLY;INTERVAL=2;COUNT=8;WKST=SU;BYDAY=TU,TH"


// (##)MonthlyStrategy
//  "RRULE:FREQ=MONTHLY;COUNT=10;BYDAY=1FR"
//  "RRULE:FREQ=MONTHLY;INTERVAL=2;COUNT=4;BYDAY=-4TU,4SU"
//  "RRULE:FREQ=MONTHLY;INTERVAL=2;COUNT=10;BYDAY=1SU,-1SU"
//  "RRULE:FREQ=MONTHLY;COUNT=6;BYDAY=-2MO"
//  "RRULE:FREQ=MONTHLY;BYMONTHDAY=-3"
//  "RRULE:FREQ=MONTHLY;COUNT=10;BYMONTHDAY=2,15"
//  "RRULE:FREQ=MONTHLY;COUNT=10;BYMONTHDAY=1,-1"
//  "RRULE:FREQ=MONTHLY;INTERVAL=18;COUNT=10;BYMONTHDAY=10,11,12,13,14,15"
//  "RRULE:FREQ=MONTHLY;INTERVAL=2;BYDAY=TU"
//  "RRULE:FREQ=MONTHLY;BYDAY=FR;BYMONTHDAY=13"
//  "RRULE:FREQ=MONTHLY;BYDAY=SA;BYMONTHDAY=7,8,9,10,11,12,13"
//  "RRULE:FREQ=MONTHLY;COUNT=3;BYDAY=TU,WE,TH;BYSETPOS=3"
//  "RRULE:FREQ=MONTHLY;BYDAY=MO,TU,WE,TH,FR;BYSETPOS=-2"




// (##) YearlyStrategy
// RRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU;UNTIL=20061029T060000Z
// RRULE:FREQ=YEARLY;BYMONTH=4;BYDAY=-1SU;UNTIL=19860427T070000Z
// RRULE:FREQ=YEARLY;BYMONTH=4;BYDAY=1SU;UNTIL=20060402T070000Z
//  RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU
//  RRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU
//  RRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU
// RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU

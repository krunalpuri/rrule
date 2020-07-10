import 'package:logger/logger.dart';
import 'package:test/test.dart';
import 'package:rrule/rrule.dart';

void main() {
  Logger.level = Level.nothing;
  test('Daily Strategy Tests - Count', () {
    DateTime testFromDate, testUntilDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = ["RRULE:FREQ=DAILY;COUNT=10"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_DAILY.index);
    testFromDate = DateTime.utc(1997, 8, 5);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 8, 11);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
  });

  test('Daily Strategy Tests - Until', () {
    DateTime testFromDate, testUntilDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = ["RRULE:FREQ=DAILY;UNTIL=19971224T000000Z"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_DAILY.index);
    testFromDate = DateTime.utc(1997, 8, 5);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 12, 25);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
  });

  test('Daily Strategy Tests - Interval', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = ["RRULE:FREQ=DAILY;INTERVAL=2"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_DAILY.index);
    testFromDate = DateTime.utc(1997, 8, 3);
    testToDate = DateTime.utc(1997, 8, 30);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate)
            .length,
        14);

    testFromDate = DateTime.utc(1997, 8, 2);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate)
            .length,
        14);
  });

  test('Daily Strategy Tests - BYMONTH', () {
    DateTime testFromDate, testUntilDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = [
      "RRULE:FREQ=DAILY;UNTIL=20000131T140000Z;BYMONTH=8"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_DAILY.index);
    testFromDate = DateTime.utc(1998, 8, 7);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1998, 9, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
  });

  test('Daily Strategy Tests - BYDAY', () {
    DateTime testFromDate, testUntilDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = [
      "RRULE:FREQ=DAILY;UNTIL=20200523T035959Z;BYDAY=SU,MO,WE"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_DAILY.index);

    testFromDate = DateTime.utc(1998, 9, 12);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
    testFromDate = DateTime.utc(1998, 9, 13);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1998, 9, 14);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1998, 9, 15);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
    testFromDate = DateTime.utc(1998, 9, 16);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1998, 9, 17);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
    testFromDate = DateTime.utc(1998, 9, 18);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
    testFromDate = DateTime.utc(1998, 9, 19);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
  });

  test('Daily Strategy Tests - BYMONTHDAY', () {
    DateTime testFromDate, testUntilDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = [
      "RRULE:FREQ=DAILY;UNTIL=20200523T035959Z;BYDAY=SU,MO,TU;BYMONTHDAY=-2,15"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_DAILY.index);
    testFromDate = DateTime.utc(1998, 9, 15);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1998, 9, 29);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1998, 8, 15);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
  });

  test('Weekly Strategy Tests', () {});

  test('Weekly Strategy Tests - Count', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = ["RRULE:FREQ=WEEKLY;COUNT=10"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_WEEKLY.index);
    testFromDate = DateTime.utc(1997, 10, 3);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 10, 10);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);

    testToDate = DateTime.utc(1998, 9, 30);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate)
            .length,
        10);
  });

  test('Weekly Strategy Tests - Until', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = ["RRULE:FREQ=WEEKLY;UNTIL=19971224T000000Z"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_WEEKLY.index);
    testFromDate = DateTime.utc(1997, 12, 19);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 12, 26);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
  });

  test('Weekly Strategy Tests - Interval', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = ["RRULE:FREQ=WEEKLY;INTERVAL=2"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_WEEKLY.index);
    testFromDate = DateTime.utc(1997, 8, 1);
    testToDate = DateTime.utc(1998, 3, 30);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate)
            .length,
        18);

    testFromDate = DateTime.utc(1997, 8, 15);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 8, 29);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1998, 3, 13);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 8, 22);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
  });

  test('Weekly Strategy Tests - BYDAY', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 5);
    List<String> recurrence = ["RRULE:FREQ=WEEKLY;COUNT=10;BYDAY=TU,TH"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_WEEKLY.index);

    testFromDate = DateTime.utc(1997, 8, 5);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 9, 9);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);

    testToDate = DateTime.utc(1998, 9, 30);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate)
            .length,
        10);
  });

  test('Weekly Strategy Tests - Interval + BYDAY + COUNT', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = [
      "RRULE:FREQ=WEEKLY;INTERVAL=2;COUNT=8;WKST=SU;BYDAY=FR,SA"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_WEEKLY.index);
    testFromDate = DateTime.utc(1997, 8, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1997, 8, 2);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1997, 9, 8);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
    testFromDate = DateTime.utc(1997, 8, 9);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
    testFromDate = DateTime.utc(1997, 8, 15);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1997, 8, 16);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testToDate = DateTime.utc(1998, 9, 30);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate)
            .length,
        8);
  });


  test('Monthly Strategy Tests', (){

  });

  test('Monthly Strategy Tests - Count', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = ["RRULE:FREQ=MONTHLY;COUNT=12"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_MONTHLY.index);
    testFromDate = DateTime.utc(1997, 9, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1998, 9, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);

    testFromDate = DateTime.utc(1997, 8, 1);
    testToDate = DateTime.utc(1998, 9, 1);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate)
            .length,
        12);
  });

  test('MONTHLY Strategy Tests - Until', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = ["RRULE:FREQ=MONTHLY;UNTIL=19971224T000000Z"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_MONTHLY.index);
    testFromDate = DateTime.utc(1997, 8, 31);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
    testFromDate = DateTime.utc(1997, 12, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1998, 1, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);

    testFromDate = DateTime.utc(1997, 8, 1);
    testToDate = DateTime.utc(1998, 9, 1);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate).length,
        5);
  });

  test('MONTHLY Strategy Tests - Interval', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = ["RRULE:FREQ=MONTHLY;INTERVAL=2"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_MONTHLY.index);
    testFromDate = DateTime.utc(1997, 8, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 9, 1);
    testToDate = DateTime.utc(1998, 9, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate).length
            ,
        6);

  });


  test('Monthly Strategy Tests - BYMONTH', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 29);
    List<String> recurrence = ["RRULE:FREQ=MONTHLY;BYMONTHDAY=-3"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_MONTHLY.index);

    testFromDate = DateTime.utc(1997, 8, 29);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 10, 3);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);

    testFromDate = DateTime.utc(1998, 10, 30);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);

    testFromDate = DateTime.utc(1998, 2, 26);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 8, 1);
    testToDate = DateTime.utc(1998, 8, 1);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate).length
            ,
        12);
  });

  test('Monthly Strategy Tests - BYDAY', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = ["RRULE:FREQ=MONTHLY;COUNT=10;BYDAY=1FR"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_MONTHLY.index);

    testFromDate = DateTime.utc(1997,9 , 5);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 8, 18);
    testToDate = DateTime.utc(1998, 12, 30);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate).length
        ,
        10);
  });

  test('Monthly Strategy Tests - Interval', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = ["RRULE:FREQ=MONTHLY;INTERVAL=2"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_MONTHLY.index);

    testFromDate = DateTime.utc(1997,9 , 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
    testFromDate = DateTime.utc(1997,12 , 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 8, 1);
    testToDate = DateTime.utc(1998, 8, 1);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate).length
        ,
        7);
  });

  // TODO: Interval and ByDAY don't work together right now
//  test('Monthly Strategy Tests - Interval,COUNT, BYDAY', () {
//    DateTime testFromDate, testToDate;
//    DateTime start = DateTime.utc(1997, 8, 1);
//    List<String> recurrence = ["RRULE:FREQ=MONTHLY;INTERVAL=2;COUNT=6;BYDAY=-4TU,4SU"];
//    RRuleParse rRuleParse = RRuleParse.googleEvent(
//        recurrence: recurrence, startTime: start, endTime: null);
//    expect(rRuleParse.parseRule().index, FreqType.FREQ_MONTHLY.index);
//
//    testFromDate = DateTime.utc(1997,8 , 5);
//    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
//    testFromDate = DateTime.utc(1997,8 , 24);
//    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
//
////    testFromDate = DateTime.utc(1997,10 , );
////    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
////    testFromDate = DateTime.utc(1997,10 , 25);
////    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
//
//    testFromDate = DateTime.utc(1997, 8, 1);
//    testToDate = DateTime.utc(1998, 8, 1);
//    expect(
//        rRuleParse
//            .getEventDates(fromDate: testFromDate, toDate: testToDate)
//        ,
//        6);
//  });
//
//  test('Yearly Strategy Tests', (){
//
//  });
//
//  test('Unsupported Strategy Tests', (){
//
//  });
}

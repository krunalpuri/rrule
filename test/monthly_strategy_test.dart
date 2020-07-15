import 'package:logger/logger.dart';
import 'package:rrule/rrule.dart';
import 'package:test/test.dart';

void main(){
  Logger.level = Level.nothing;
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

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
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
            .getEventDates(fromDate: testFromDate, toDate: testToDate)
            .length,
        5);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
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
            .getEventDates(fromDate: testFromDate, toDate: testToDate)
            .length,
        6);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
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
            .getEventDates(fromDate: testFromDate, toDate: testToDate)
            .length,
        12);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });

  test('Monthly Strategy Tests - BYDAY', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = ["RRULE:FREQ=MONTHLY;COUNT=10;BYDAY=1FR"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_MONTHLY.index);

    testFromDate = DateTime.utc(1997, 9, 5);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 8, 18);
    testToDate = DateTime.utc(1998, 12, 30);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate)
            .length,
        10);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });

  test('Monthly Strategy Tests - Interval', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = ["RRULE:FREQ=MONTHLY;INTERVAL=2"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_MONTHLY.index);

    testFromDate = DateTime.utc(1997, 9, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
    testFromDate = DateTime.utc(1997, 12, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 8, 1);
    testToDate = DateTime.utc(1998, 8, 1);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate)
            .length,
        7);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });

  test('Monthly Strategy Tests - Interval,COUNT, BYDAY', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = [
      "RRULE:FREQ=MONTHLY;INTERVAL=2;COUNT=6;BYDAY=-4TU,4SU"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_MONTHLY.index);

    testFromDate = DateTime.utc(1997, 8, 5);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1997, 8, 24);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 9, 9);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
    testFromDate = DateTime.utc(1997, 9, 28);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);

    testFromDate = DateTime.utc(1997, 10, 7);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1997, 10, 26);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 8, 1);
    testToDate = DateTime.utc(1998, 8, 1);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate).length
        ,
        6);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });

  test('Monthly Strategy Tests - INTERVAL, COUNT, BYMONTHDAY', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 9, 10);
    List<String> recurrence = [
      "RRULE:FREQ=MONTHLY;INTERVAL=18;COUNT=10;BYMONTHDAY=10,11,12,13,14,15"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_MONTHLY.index);

    testFromDate = DateTime.utc(1997, 9, 10);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1999, 3, 10);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);


    testFromDate = DateTime.utc(1999, 3, 14);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);

    testFromDate = DateTime.utc(1997, 8, 1);
    testToDate = DateTime.utc(2000, 8, 1);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate).length
        ,
        10);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });

  test('Monthly Strategy Tests - BYDAY, BYMONTHDAY', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 9, 10);
    List<String> recurrence = [
      "RRULE:FREQ=MONTHLY;BYDAY=SA;BYMONTHDAY=7,8,9,10,11,12,13"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_MONTHLY.index);

    testFromDate = DateTime.utc(1997, 9, 13);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 10, 11);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1998, 1, 9);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);

    testFromDate = DateTime.utc(1997, 8, 1);
    testToDate = DateTime.utc(1998, 7, 1);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate).length
        ,
        10);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });
}
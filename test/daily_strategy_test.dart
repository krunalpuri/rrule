import 'package:rrule/rrule.dart';
import 'package:test/test.dart';

dailyFreqTest(){
  test('Daily Strategy Tests - Count', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = ["RRULE:FREQ=DAILY;COUNT=10"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_DAILY.index);
    testFromDate = DateTime.utc(1997, 8, 5);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 8, 11);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);

    testToDate = DateTime.utc(1998, 8, 11);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });

  test('Daily Strategy Tests - Until', () {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = ["RRULE:FREQ=DAILY;UNTIL=19971224T000000Z"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_DAILY.index);
    testFromDate = DateTime.utc(1997, 8, 5);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 12, 25);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);

    testToDate = DateTime.utc(1998, 12, 25);
    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
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

    testFromDate = DateTime.utc(1997, 8, 1);
    testToDate = DateTime.utc(1997, 8, 30);
    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });

  test('Daily Strategy Tests - BYMONTH', () {
    DateTime testFromDate, testToDate;
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

    testFromDate = DateTime.utc(1997, 8, 1);
    testToDate = DateTime.utc(1998, 8, 7);
    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });

  test('Daily Strategy Tests - BYDAY', () {
    DateTime testFromDate, testToDate;
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

    testFromDate = DateTime.utc(1998, 9, 12);
    testToDate = DateTime.utc(1999, 9, 19);
    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });

  test('Daily Strategy Tests - BYMONTHDAY', () {
    DateTime testFromDate, testToDate;
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

    testFromDate = DateTime.utc(1997, 8, 1);
    testToDate = DateTime.utc(1998, 9, 30);
    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });
}
import 'package:rrule/rrule.dart';
import 'package:test/test.dart';

weeklyFreqTest(){
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

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
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

    testFromDate = DateTime.utc(1997, 12, 1);
    testToDate = DateTime.utc(1998, 12, 1);
    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
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

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
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

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });

  test('Weekly Strategy Tests - Interval, BYDAY, COUNT', () {
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

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });
}
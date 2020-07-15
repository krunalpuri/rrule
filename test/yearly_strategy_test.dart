import 'package:rrule/rrule.dart';
import 'package:test/test.dart';

yearlyFreqTest(){
  test('Yearly Strategy Tests - Count', (){
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = [
      "RRULE:FREQ=YEARLY;COUNT=10"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_YEARLY.index);

    testFromDate = DateTime.utc(1997, 8, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1997, 9, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
    testFromDate = DateTime.utc(1998, 8, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(2007, 8, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);

    testFromDate = DateTime.utc(1997, 8, 1);
    testToDate = DateTime.utc(2008, 7, 1);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate).length
        ,
        10);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });

  test('Yearly Strategy Tests - Until', ()
  {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = [
      "RRULE:FREQ=YEARLY;UNTIL=20000131T140000Z"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse
        .parseRule()
        .index, FreqType.FREQ_YEARLY.index);

    testFromDate = DateTime.utc(1997, 8, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1999, 8, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(2000, 8, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);

    testFromDate = DateTime.utc(1997, 8, 1);
    testToDate = DateTime.utc(2008, 7, 1);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate).length
        ,
        3);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });

  test('Yearly Strategy Tests - Interval', ()
  {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = [
      "RRULE:FREQ=YEARLY;INTERVAL=2"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse
        .parseRule()
        .index, FreqType.FREQ_YEARLY.index);

    testFromDate = DateTime.utc(1997, 8, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1998, 8, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
    testFromDate = DateTime.utc(2006, 8, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);

    testFromDate = DateTime.utc(1997, 8, 1);
    testToDate = DateTime.utc(2008, 7, 1);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate).length
        ,
        6);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });

  test('Yearly Strategy Tests - BYMONTH', ()
  {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 3, 1);
    List<String> recurrence = [
      "RRULE:FREQ=YEARLY;BYMONTH=3"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse
        .parseRule()
        .index, FreqType.FREQ_YEARLY.index);

    testFromDate = DateTime.utc(1997, 3, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1998, 3, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(2006, 3, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 8, 1);
    testToDate = DateTime.utc(2008, 7, 1);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate).length
        ,
        11);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });

  test('Yearly Strategy Tests - BYDAY', ()
  {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 5, 19);
    List<String> recurrence = [
      "RRULE:FREQ=YEARLY;BYDAY=20MO"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse
        .parseRule()
        .index, FreqType.FREQ_YEARLY.index);

    testFromDate = DateTime.utc(1997, 5, 19);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1998, 5, 18);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1999, 5, 17);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1997, 1, 1);
    testToDate = DateTime.utc(2007, 1, 1);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate).length
        ,
        10);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });


  test('Yearly Strategy Tests - BYMONTHDAY', ()
  {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 8, 6);
    List<String> recurrence = [
      "RRULE:FREQ=YEARLY;BYMONTH=6,7,8"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse
        .parseRule()
        .index, FreqType.FREQ_YEARLY.index);

    testFromDate = DateTime.utc(1997, 8, 6);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1998, 6, 6);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1998, 7, 6);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1998, 8, 6);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1998, 9, 6);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);

    testFromDate = DateTime.utc(1997, 8, 1);
    testToDate = DateTime.utc(2000, 8, 1);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate).length
        ,
        9);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });


  test('Yearly Strategy Tests - BYMONTH, BYDAY', ()
  {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 3, 13);
    List<String> recurrence = [
      "RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=TH"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse
        .parseRule()
        .index, FreqType.FREQ_YEARLY.index);

    testFromDate = DateTime.utc(1997, 3, 13);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1997, 3, 20);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1997, 3, 27);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1998, 3, 5);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1998, 3, 12);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1998, 3, 19);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1998, 3, 26);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1998, 3, 27);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);
    testFromDate = DateTime.utc(1998, 4, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);

    testFromDate = DateTime.utc(1997, 3, 1);
    testToDate = DateTime.utc(2000, 1, 1);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate).length
        ,
        11);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });

  test('Yearly Strategy Tests - BYMONTH, BYDAY, BYMONTHDAY', ()
  {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1996, 11, 5);
    List<String> recurrence = [
      "RRULE:FREQ=YEARLY;INTERVAL=4;BYMONTH=11;BYDAY=TU;BYMONTHDAY=2,3,4,5,6,7,8"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse
        .parseRule()
        .index, FreqType.FREQ_YEARLY.index);

    testFromDate = DateTime.utc(1997, 11, 4);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);


    testFromDate = DateTime.utc(1996, 3, 1);
    testToDate = DateTime.utc(2008, 1, 1);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate).length
        ,
        3);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });

  test('Yearly Strategy Tests - BYMONTH, COUNT', ()
  {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 6, 10);
    List<String> recurrence = [
      "RRULE:FREQ=YEARLY;COUNT=9;BYMONTH=6,7"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse
        .parseRule()
        .index, FreqType.FREQ_YEARLY.index);

    testFromDate = DateTime.utc(1997, 6, 10);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(2001, 6, 10);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(2001, 7, 10);
    expect(rRuleParse.checkEventStatusOn(testFromDate), false);

    testFromDate = DateTime.utc(1996, 3, 1);
    testToDate = DateTime.utc(2008, 1, 1);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate).length
        ,
        9);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });
  });

  test('Yearly Strategy Tests - BYWEEKNO, BYDAY', ()
  {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 5, 12);
    List<String> recurrence = [
      "RRULE:FREQ=YEARLY;BYWEEKNO=20;BYDAY=MO"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse
        .parseRule()
        .index, FreqType.FREQ_YEARLY.index);
//
    testFromDate = DateTime.utc(1997, 5, 12);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1998, 5, 11);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1999, 5, 17);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1999, 5, 17);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1996, 3, 1);
    testToDate = DateTime.utc(2008, 1, 1);
    expect(
        rRuleParse
            .getEventDates(fromDate: testFromDate, toDate: testToDate).length
        ,
        11);

    rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).forEach((date) {
      expect(rRuleParse.checkEventStatusOn(date), true);
    });


  });

  test('Yearly Strategy Tests - BYYEARDAY', ()
  {
    DateTime testFromDate, testToDate;
    DateTime start = DateTime.utc(1997, 1, 1);
    List<String> recurrence = [
      "RRULE:FREQ=YEARLY;INTERVAL=3;COUNT=10;BYYEARDAY=-2,1,100,200"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse
        .parseRule()
        .index, FreqType.FREQ_YEARLY.index);

    testFromDate = DateTime.utc(1997, 1, 1);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1997, 4, 10);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1997, 7, 19);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);
    testFromDate = DateTime.utc(1997, 12, 30);
    expect(rRuleParse.checkEventStatusOn(testFromDate), true);

    testFromDate = DateTime.utc(1996, 3, 1);
    testToDate = DateTime.utc(2008, 1, 1);
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
import 'package:logger/logger.dart';
import 'package:test/test.dart';
import 'package:rrule/rrule.dart';

void main() {

  Logger.level = Level.nothing;
  test('Daily Strategy Tests - Count', (){
    DateTime testFromDate,testUntilDate;
    DateTime start = DateTime(1997, 8, 1).toUtc();
    List<String> recurrence = [
      "RRULE:FREQ=DAILY;COUNT=10"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index,FreqType.FREQ_DAILY.index);
    testFromDate = DateTime(1997, 8, 5).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);

    testFromDate = DateTime(1997, 8, 11).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),false);
  });

  test('Daily Strategy Tests - Until', (){
    DateTime testFromDate,testUntilDate;
    DateTime start = DateTime(1997, 8, 1).toUtc();
    List<String> recurrence = [
      "RRULE:FREQ=DAILY;UNTIL=19971224T000000Z"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index,FreqType.FREQ_DAILY.index);
    testFromDate = DateTime(1997, 8, 5).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);

    testFromDate = DateTime(1997, 12, 25).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),false);
  });

  test('Daily Strategy Tests - Interval', (){
    DateTime testFromDate,testToDate;
    DateTime start = DateTime(1997, 8, 1).toUtc();
    List<String> recurrence = [
      "RRULE:FREQ=DAILY;INTERVAL=2"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index,FreqType.FREQ_DAILY.index);
    testFromDate = DateTime(1997, 8, 3).toUtc();
    testToDate = DateTime(1997, 8, 30).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);
    expect(rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).length,14);

    testFromDate = DateTime(1997, 8, 2).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),false);
    expect(rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).length,14);
  });

  test('Daily Strategy Tests - BYMONTH', (){
    DateTime testFromDate,testUntilDate;
    DateTime start = DateTime(1997, 8, 1).toUtc();
    List<String> recurrence = [
      "RRULE:FREQ=DAILY;UNTIL=20000131T140000Z;BYMONTH=8"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index,FreqType.FREQ_DAILY.index);
    testFromDate = DateTime(1998, 8, 7).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);

    testFromDate = DateTime(1998, 9, 1).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),false);
  });

  test('Daily Strategy Tests - BYDAY', (){
    DateTime testFromDate,testUntilDate;
    DateTime start = DateTime(1997, 8, 1).toUtc();
    List<String> recurrence = [
      "RRULE:FREQ=DAILY;UNTIL=20200523T035959Z;BYDAY=SU,MO,WE"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index,FreqType.FREQ_DAILY.index);

    testFromDate = DateTime(1998, 9, 12).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),false);
    testFromDate = DateTime(1998, 9, 13).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);
    testFromDate = DateTime(1998, 9, 14).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);
    testFromDate = DateTime(1998, 9, 15).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),false);
    testFromDate = DateTime(1998, 9, 16).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);
    testFromDate = DateTime(1998, 9, 17).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),false);
    testFromDate = DateTime(1998, 9, 18).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),false);
    testFromDate = DateTime(1998, 9, 19).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),false);
  });

  test('Daily Strategy Tests - BYMONTHDAY', (){
    DateTime testFromDate,testUntilDate;
    DateTime start = DateTime(1997, 8, 1).toUtc();
    List<String> recurrence = [
      "RRULE:FREQ=DAILY;UNTIL=20200523T035959Z;BYDAY=SU,MO,TU;BYMONTHDAY=-2,15"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index,FreqType.FREQ_DAILY.index);
    testFromDate = DateTime(1998, 9, 15).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);
    testFromDate = DateTime(1998, 9, 28).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);
    testFromDate = DateTime(1998, 8, 15).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),false);
  });



  test('Weekly Strategy Tests', (){

  });


  test('Weekly Strategy Tests - Count', (){
    DateTime testFromDate,testToDate;
    DateTime start = DateTime(1997, 8, 1).toUtc();
    List<String> recurrence = [
      "RRULE:FREQ=WEEKLY;COUNT=10"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index,FreqType.FREQ_WEEKLY.index);
    testFromDate = DateTime(1997, 10, 3).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);

    testFromDate = DateTime(1997, 10, 10).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),false);

    testToDate = DateTime(1998, 9, 30).toUtc();
    expect(rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).length,10);
  });


  test('Weekly Strategy Tests - Until', (){
    DateTime testFromDate,testToDate;
    DateTime start = DateTime(1997, 8, 1).toUtc();
    List<String> recurrence = [
      "RRULE:FREQ=WEEKLY;UNTIL=19971224T000000Z"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index,FreqType.FREQ_WEEKLY.index);
    testFromDate = DateTime(1997, 12, 19).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);

    testFromDate = DateTime(1997, 12, 26).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),false);
  });

  test('Weekly Strategy Tests - Interval', (){
    DateTime testFromDate,testToDate;
    DateTime start = DateTime(1997, 8, 1).toUtc();
    List<String> recurrence = [
      "RRULE:FREQ=WEEKLY;INTERVAL=2"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index,FreqType.FREQ_WEEKLY.index);
    testFromDate = DateTime(1997, 8, 1).toUtc();
    testToDate = DateTime(1998, 3, 30).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);
    expect(rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).length,18);

    testFromDate = DateTime(1997, 8, 15).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);

    testFromDate = DateTime(1997, 8, 29).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);

    testFromDate = DateTime(1998, 3, 13).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);

    testFromDate = DateTime(1997, 8, 22).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),false);
  });


  test('Weekly Strategy Tests - BYDAY', (){
    DateTime testFromDate,testToDate;
    DateTime start = DateTime(1997, 8, 5).toUtc();
    List<String> recurrence = [
      "RRULE:FREQ=WEEKLY;COUNT=10;BYDAY=TU,TH"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index,FreqType.FREQ_WEEKLY.index);

    testFromDate = DateTime(1997, 8, 5).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);

    testFromDate = DateTime(1997, 9, 9).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),false);

    testToDate = DateTime(1998, 9, 30).toUtc();
    expect(rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).length,10);
  });


  test('Weekly Strategy Tests - Interval + BYDAY + COUNT', (){
    DateTime testFromDate,testToDate;
    DateTime start = DateTime(1997, 8, 1).toUtc();
    List<String> recurrence = [
      "RRULE:FREQ=WEEKLY;INTERVAL=2;COUNT=8;WKST=SU;BYDAY=FR,SA"
    ];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index,FreqType.FREQ_WEEKLY.index);
    testFromDate = DateTime(1997, 8, 1).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);
    testFromDate = DateTime(1997, 8, 2).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);
    testFromDate = DateTime(1997, 9, 8).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),false);
    testFromDate = DateTime(1997, 8, 9).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),false);
    testFromDate = DateTime(1997, 8, 15).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);
    testFromDate = DateTime(1997, 8, 16).toUtc();
    expect(rRuleParse.checkEventStatusOn(testFromDate),true);
    testToDate = DateTime(1998, 9, 30).toUtc();
    expect(rRuleParse.getEventDates(fromDate: testFromDate, toDate: testToDate).length,8);
  });


//
//  test('Monthly Strategy Tests', (){
//
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



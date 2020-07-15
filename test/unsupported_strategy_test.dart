import 'package:rrule/rrule.dart';
import 'package:test/test.dart';

unsupportedFreqTest(){
  test('Unsupported Strategy Tests - Secondly', () {
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = ["RRULE:FREQ=SECONDLY;COUNT=10"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_UNSUPPORTED.index);

  });

  test('Unsupported Strategy Tests - Minutely', () {
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = ["RRULE:FREQ=MINUTELY;COUNT=10"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_UNSUPPORTED.index);

  });

  test('Unsupported Strategy Tests - Hourly', () {
    DateTime start = DateTime.utc(1997, 8, 1);
    List<String> recurrence = ["RRULE:FREQ=HOURLY;COUNT=10"];
    RRuleParse rRuleParse = RRuleParse.googleEvent(
        recurrence: recurrence, startTime: start, endTime: null);
    expect(rRuleParse.parseRule().index, FreqType.FREQ_UNSUPPORTED.index);

  });
}
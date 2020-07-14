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


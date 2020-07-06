import 'package:rrule/src/FreqStrategy.dart';
import 'Strategies/Strategies.dart';

class FreqStrategyFactory {
  static FreqStrategy getFreqStrategy({rulePartMap, startTime, endTime}) {
    switch (rulePartMap["FREQ"]) {
      case "DAILY":
        return DailyStrategy(rulePartMap, startTime, endTime);
      case "WEEKLY":
        return WeeklyStrategy(rulePartMap, startTime, endTime);
      case "MONTHLY":
        return MonthlyStrategy(rulePartMap, startTime, endTime);
      case "YEARLY":
        return YearlyStrategy(rulePartMap, startTime, endTime);
      default:
        return UnsupportedStrategy(rulePartMap, startTime, endTime);
    }
  }
}




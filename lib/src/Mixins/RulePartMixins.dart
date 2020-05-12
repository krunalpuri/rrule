mixin ByMonth {
  checkByMonth(byMonth, inputDate) {
    return (byMonth != null && !byMonth.contains(inputDate.month))
        ? false
        : true;
  }
}


mixin ByMonthDay {
  checkByMonthDay(byMonthDay, inputDate) {
    if (byMonthDay != null) {
      // get the inputDate monthDay (date and count from last date)
      int monthDay = inputDate.day;
      // Setting date zero for next month gives last date of current month
      var monthEndDate = DateTime(inputDate.year, inputDate.month + 1, 0);
      // inputDay minus the monthEndDay
      int monthDayNegative = monthDay - monthEndDate.day;

      // if neither values are in byMonthDay list, return false
      return (!(byMonthDay.contains(monthDay) ||
          byMonthDay.contains(monthDayNegative))) ? false : true;
    }
    else {
      return true;
    }
  }
}


mixin ByDay {
  checkByDay(byDay, inputDate) {
    return (byDay != null && !byDay.contains(inputDate.weekday)) ? false : true;
  }
}



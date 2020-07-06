int convertWeekdaysToInt(String weekday) {
  switch (weekday) {
    case "MO":
      return 1;
    case "TU":
      return 2;
    case "WE":
      return 3;
    case "TH":
      return 4;
    case "FR":
      return 5;
    case "SA":
      return 6;
    case "SU":
      return 7;
    default:
      {
        throw Exception("BYDAY: Weekday has incorrect value");
      }
  }
}